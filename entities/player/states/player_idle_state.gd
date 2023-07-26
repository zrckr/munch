extends State

@export_range(1, 400, 1, 'suffix:px/s') var deceleration_speed: float
@export var wait_timer: Timer
@export var ears_timer: Timer

@export_group('Player Dependencies')
@export var player: Entity
@export var player_animations: EntityAnimations


func _ready() -> void:
	wait_timer.timeout.connect(on_wait_timer_timeout)
	ears_timer.timeout.connect(on_ears_timer_timeout)


func transition_attempts() -> void:
	match state_machine.current_state.name:
		&'Move':
			if not Inputs.has_movement:
				state_machine.transition_to(&'Idle')


func begin(_kwargs := {}) -> void:
	on_ears_timer_timeout()


func act(delta: float) -> void:
	player.velocity = player.velocity.lerp(Vector2.ZERO, deceleration_speed * delta)
	player.move_and_slide()


func end() -> void:
	wait_timer.stop()
	ears_timer.stop()


func on_wait_timer_timeout() -> void:
	player_animations.play('idle_ears');
	ears_timer.start()


func on_ears_timer_timeout() -> void:
	player_animations.direction = (
		player.velocity if not player.velocity.is_zero_approx()
		else Vector2.DOWN
	)
	
	player_animations.play('idle')
	wait_timer.start()
