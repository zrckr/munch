extends EntityAction

@export_range(0.1, 10.0, 0.1)
var rotation_amount: float

@export_exp_easing('positives_only')
var acceleration_weight: float

@onready
var _hitbox: CollisionBox = $HitBox


func _transition_attempts() -> void:
	match state.action:
		&'Idle':
			if Inputs.has_movement:
				state.action = &'Move'


func _begin() -> void:
	_hitbox.enable()


func _act(delta: float) -> void:
	state.facing_direction = Vector2i(entity.transform.y.round())
	
	if Inputs.has_movement:
		var target_angle = Inputs.movement.angle() - Math.HALF_PI
		entity.rotation = lerp_angle(entity.rotation, target_angle, rotation_amount * delta)
	
	var input_amount = Inputs.movement.length_squared()
	var target_velocity = entity.transform.y * input_amount * properties.speed
	
	entity.velocity = entity.velocity.move_toward(target_velocity, acceleration_weight)
	entity.move_and_slide()
	
	var speed_amount = entity.velocity.length() / properties.speed
	animations.rolling(speed_amount * -1.0)


func _end() -> void:
	_hitbox.disable()


func _is_action_active() -> bool:
	return state.action == &'Move'
