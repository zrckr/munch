extends State

@export_range(0.1, 1, 0.1, 'suffix:seconds') var suction_time: float
@export_range(1, 10, 1, 'suffix:entities') var suction_capacity: int
@export var particle_attractor: ParticleAttractor
@export var suck_box: CollisionBox
@export var capacity_label: Label

@export_group('Hoover Dependencies')
@export var hoover: Entity
@export var hoover_animations: EntityAnimations
@export var hoover_blackboard: HooverBlackboard


func _ready() -> void:
	await hoover.ready
	
	hoover_blackboard.suction_callback = func(value):
		capacity_label.text = ('%01d' % value) if value > 0 else ''
	
	hoover_blackboard.suction_amount = 0


func _process(_delta: float) -> void:
	suck_box.rotation = hoover_blackboard.get_suction_angle()
	particle_attractor.rotation = hoover_blackboard.get_suction_angle()


func transition_attempts() -> void:
	match state_machine.current_state.name:
		&'Idle', &'Move':
			if hoover_blackboard.empty_capacity and Inputs.attack.just_pressed:
				state_machine.transition_to(&'Suck')
		&'Suck':
			if hoover_blackboard.enough_capacity and Inputs.attack.just_released:
				state_machine.transition_to(&'Idle')


func begin(_kwargs := {}) -> void:
	suck_box.enable()
	particle_attractor.start_emitting()
	
	hoover_animations.direction = hoover_blackboard.facing_direction
	hoover_animations.play('hoover/suck')


func act(_delta: float) -> void:
	var bodies = suck_box.get_overlapping_bodies().duplicate()
	if bodies.is_empty():
		return
	
	bodies.sort_custom(sort_bodies_by_distance)
	for i in range(len(bodies)):
		if (i + 1) <= suction_capacity:
			suck_the_body(bodies[i])


func suck_the_body(body: PhysicsBody2D) -> void:
	if hoover_blackboard.suction_tweens.has(body):
		return
	
	body.process_mode = Node.PROCESS_MODE_DISABLED
	body.disable_mode = CollisionObject2D.DISABLE_MODE_REMOVE
	
	var tween = create_tween() \
		.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS) \
		.set_pause_mode(Tween.TWEEN_PAUSE_BOUND) \
		.set_trans(Tween.TRANS_CUBIC) \
		.set_ease(Tween.EASE_IN) \
		.set_parallel()
	
	tween.tween_property(body, 'position', hoover.global_position, suction_time)
	tween.tween_property(body, 'scale', Vector2.ZERO, suction_time)
	tween.finished.connect(on_suction_tween_finished.bind(body))
	hoover_blackboard.suction_tweens[body] = tween


func on_suction_tween_finished(body: PhysicsBody2D) -> void:
	hoover_blackboard.suction_amount += 1  
	hoover_blackboard.suction_tweens.erase(body)
	body.queue_free()


func clear_suction_tweens() -> void:
	var bodies = hoover_blackboard.suction_tweens.keys().duplicate()
	for body in bodies:
		if hoover_blackboard.suction_tweens[body]:
			hoover_blackboard.suction_tweens[body].kill()
		if is_instance_valid(body):
			body.queue_free()


func end() -> void:
	clear_suction_tweens()
	suck_box.disable()
	particle_attractor.stop_emitting()
	
	hoover_animations.play('hoover/RESET')
	hoover_animations.reset()


func sort_bodies_by_distance(a: PhysicsBody2D, b: PhysicsBody2D) -> bool:
	var a_distance := hoover.global_position.distance_to(a.global_position)
	var b_distance := hoover.global_position.distance_to(b.global_position)
	return a_distance < b_distance
