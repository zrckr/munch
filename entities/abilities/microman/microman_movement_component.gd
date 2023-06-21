extends MovementComponent

@export_exp_easing('attenuation')
var movement_ease: float


func _physics_process(_delta: float) -> void:
	_current_direction = Input.get_vector('left', 'right', 'up', 'down')
	var target_velocity = _current_direction * _current_speed
	
	_entity.velocity = Math.smooth_stepv(_entity.velocity, target_velocity, movement_ease)
	_entity.move_and_slide()
	
	if _entity.animation_component:
		if _current_direction.is_zero_approx():
			_entity.animation_component.play_idle()
		else:
			_entity.animation_component.play_move(facing_direction)
