extends State

@export
var velocity_component: VelocityComponent

@export_group('Player Dependencies')
@export var player: Entity
@export var player_animations: EntityAnimations


func transition_attempts() -> void:
	match state_machine.current_state.name:
		&'Idle':
			if Inputs.has_movement:
				state_machine.transition_to(&'Move')


func act(_delta: float) -> void:
	velocity_component.accelerate_to_direction(Inputs.movement)
	velocity_component.move()
	
	player_animations.direction = Inputs.movement
	player_animations.play('move')
