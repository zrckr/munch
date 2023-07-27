extends State

@export
var velocity_component: VelocityComponent

@export_group('State Dependencies')
@export var wait_timer: Timer
@export var ears_timer: Timer

@export_group('Player Dependencies')
@export var player: Entity
@export var player_animations: EntityAnimations


func transition_attempts() -> void:
	match state_machine.current_state.name:
		&'Move':
			if not Inputs.has_movement:
				state_machine.transition_to(&'Idle')


func begin(_kwargs := {}) -> void:
	_on_ears_timer_timeout()


func act(_delta: float) -> void:
	velocity_component.decelerate_to_zero()
	velocity_component.move()


func end() -> void:
	wait_timer.stop()
	ears_timer.stop()


func _on_wait_timer_timeout() -> void:
	player_animations.play('idle_ears');
	ears_timer.start()


func _on_ears_timer_timeout() -> void:
	player_animations.direction = (
		player.velocity if not player.velocity.is_zero_approx()
		else Vector2.DOWN
	)
	
	player_animations.play('idle')
	wait_timer.start()
