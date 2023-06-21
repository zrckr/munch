extends MovementComponent

@export_range(0.1, 10.0, 0.1)
var rotation_amount: float

@export_range(0.1, 10.0, 0.1)
var acceleration_amount: float

var _rotation_direction := 0.0


func _physics_process(delta: float) -> void:
	var movement_direction = Input.get_axis('down', 'up')
	
	var target_velocity = _entity.transform.y * movement_direction * _current_speed
	_entity.rotation += _rotation_direction * rotation_amount * delta
	_entity.velocity = _entity.velocity.move_toward(target_velocity, acceleration_amount)
	_entity.move_and_slide()
	
	var vertical_amount = _entity.velocity.length() / _current_speed
	var vertical_sign = -signf(movement_direction)
	_entity.animation_component \
		.play_rolling_vertical(vertical_amount * vertical_sign)
	
	if vertical_amount < 0.667:
		_rotation_direction = 0.0
		_entity.hitbox_component.disable()
	else:
		_rotation_direction = Input.get_axis('left', 'right')
		_entity.hitbox_component.enable()
	
	if not is_zero_approx(vertical_sign):
		_entity.hitbox_component.scale.y = -vertical_sign
