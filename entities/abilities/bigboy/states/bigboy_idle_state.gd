extends State

@export_group('BigBoy Dependencies')
@export var bigboy: Entity
@export var bigboy_animations: EntityAnimations


func transition_attempts() -> void:
	match state_machine.current_state.name:
		&'Move':
			var no_input = not Inputs.has_movement
			var no_velocity = bigboy.velocity.is_zero_approx()
			
			if no_input and no_velocity:
				state_machine.transition_to(&'Idle')
