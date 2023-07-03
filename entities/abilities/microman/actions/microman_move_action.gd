extends EntityAction

@export_exp_easing('positive_only')
var acceleration_weight: float


func _transition_attempts() -> void:
	match state.action:
		&'Idle':
			if not _get_input().is_zero_approx():
				state.action = &'Move'


func _act(_delta: float) -> void:
	state.facing_direction = Vector2i(_get_input().round())
	animations.move(state.facing_direction, 1.5)
	
	var target_velocity = _get_input() * properties.speed
	entity.velocity = Math.smooth_stepv(
			entity.velocity, target_velocity, acceleration_weight)
	entity.move_and_slide()


func _is_action_active() -> bool:
	return state.action == &'Move'


func _get_input() -> Vector2:
	return Input.get_vector('left', 'right', 'up', 'down')
