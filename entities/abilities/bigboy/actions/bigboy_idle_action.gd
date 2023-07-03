extends EntityAction


func _transition_attempts() -> void:
	match state.action:
		&'Move':
			var no_input = _get_input().is_zero_approx()
			var no_velocity = entity.velocity.is_zero_approx()
			if no_input and no_velocity:
				state.action = &'Idle'


func _is_action_active() -> bool:
	return state.action == &'Idle'


func _get_input() -> Vector2:
	return Input.get_vector('left', 'right', 'up', 'down')
