extends EntityAction

@export_range(0.1, 1, 0.1, 'suffix:seconds')
var suction_time: float

@export_range(1, 10, 1, 'suffix:entities')
var suction_capacity: int

@onready
var _particle_attractor: ParticleAttractor = $ParticleAttractor

@onready
var _suck_box: CollisionBox = $SuckBox

@onready
var _capacity_label: Label = $CapacityLabel


func _ready() -> void:
	await entity.ready
	
	state.suction_callback = func(value):
		_capacity_label.text = ('%01d' % value) if value > 0 else ''
	
	state.suction_amount = 0


func _process(_delta: float) -> void:
	_suck_box.rotation = state.get_suction_angle()
	_particle_attractor.rotation = state.get_suction_angle()


func _transition_attempts() -> void:
	match state.action:
		&'Idle', &'Move':
			var empty_capacity = state.suction_amount == 0
			if empty_capacity and Inputs.attack.just_pressed:
				state.action = &'Suck'
		
		&'Suck':
			var enough_capacity = state.suction_amount >= 0
			if enough_capacity and Inputs.attack.just_released:
				state.action = &'Idle'


func _begin() -> void:
	_suck_box.enable()
	_particle_attractor.start_emitting()
	animations.suck(state.facing_direction)


func _act(_delta: float) -> void:
	var bodies = _suck_box.get_overlapping_bodies().duplicate()
	if bodies.is_empty():
		return
	
	bodies.sort_custom(_sort_bodies_by_distance)
	for i in range(len(bodies)):
		if (i + 1) <= suction_capacity:
			_suck_the_body(bodies[i])


func _suck_the_body(body: PhysicsBody2D) -> void:
	if state.suction_tweens.has(body):
		return
	
	body.process_mode = Node.PROCESS_MODE_DISABLED
	body.disable_mode = CollisionObject2D.DISABLE_MODE_REMOVE
	
	var tween = create_tween() \
		.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS) \
		.set_pause_mode(Tween.TWEEN_PAUSE_BOUND) \
		.set_trans(Tween.TRANS_CUBIC) \
		.set_ease(Tween.EASE_IN) \
		.set_parallel()
	
	tween.tween_property(body, 'position', entity.global_position, suction_time)
	tween.tween_property(body, 'scale', Vector2.ZERO, suction_time)
	tween.finished.connect(_on_suction_tween_finished.bind(body))
	state.suction_tweens[body] = tween


func _on_suction_tween_finished(body: PhysicsBody2D) -> void:
	state.suction_amount += 1  
	state.suction_tweens.erase(body)
	body.queue_free()


func _clear_suction_tweens() -> void:
	var bodies = state.suction_tweens.keys().duplicate()
	for body in bodies:
		if state.suction_tweens[body]:
			state.suction_tweens[body].kill()
		if is_instance_valid(body):
			body.queue_free()


func _end() -> void:
	_clear_suction_tweens()
	_suck_box.disable()
	_particle_attractor.stop_emitting()
	animations.reset()


func _is_action_active() -> bool:
	return state.action == &'Suck'


func _sort_bodies_by_distance(a: PhysicsBody2D, b: PhysicsBody2D) -> bool:
	var a_distance := entity.global_position.distance_to(a.global_position)
	var b_distance := entity.global_position.distance_to(b.global_position)
	return a_distance < b_distance
