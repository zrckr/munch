extends State

@export_range(1, 400, 1, 'suffix:px/s') var acceleration_speed: float

@export_group('Player Dependencies')
@export var player: Entity
@export var player_animations: EntityAnimations


func transition_attempts() -> void:
	match state_machine.current_state.name:
		&'Idle':
			if Inputs.has_movement:
				state_machine.transition_to(&'Move')


func act(delta: float) -> void:
	var target_velocity = Inputs.movement * player.properties.speed
	player.velocity = player.velocity.lerp(target_velocity, acceleration_speed * delta)
	player.move_and_slide()

	player_animations.direction = Inputs.movement
	player_animations.play('move')
