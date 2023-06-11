extends MovementComponent


func _physics_process(_delta: float) -> void:
	_current_direction = Input.get_vector('left', 'right', 'up', 'down')
	_entity.velocity = _current_direction * _current_speed
	_entity.move_and_slide()
	
	if _entity.animation_component:
		if _current_direction.is_zero_approx():
			_entity.animation_component.play_idle()
		else:
			_entity.animation_component.play_move(facing_direction)
