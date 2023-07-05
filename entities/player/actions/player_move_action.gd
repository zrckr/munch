extends EntityAction

@export_exp_easing('positive_only')
var acceleration_weight: float


func _transition_attempts() -> void:
	match state.action:
		&'Idle':
			if Inputs.has_movement:
				state.action = &'Move'


func _act(_delta: float) -> void:
	state.facing_direction = Inputs.movement_approx
	animations.move(state.facing_direction)
	
	var target_velocity = Inputs.movement * properties.speed
	entity.velocity = Math.smooth_stepv(
			entity.velocity, target_velocity, acceleration_weight)
	entity.move_and_slide()


func _is_action_active() -> bool:
	return state.action == &'Move'
