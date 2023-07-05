extends EntityAction

@export_exp_easing('positive_only')
var deceleration_weight: float

@onready
var _wait_timer: Timer = $WaitTimer

@onready
var _ears_timer: Timer = $EarsTimer


func _transition_attempts() -> void:
	match state.action:
		&'Move':
			if not Inputs.has_movement:
				state.action = &'Idle'


func _begin() -> void:
	_on_ears_timer_timeout()


func _act(_delta: float) -> void:	
	entity.velocity = Math.smooth_stepv(
			entity.velocity, Vector2.ZERO,deceleration_weight)
	entity.move_and_slide()


func _end() -> void:
	_wait_timer.stop()
	_ears_timer.stop()


func _on_wait_timer_timeout() -> void:
	state.facing_direction = Vector2.DOWN
	animations.idle_ears()
	_ears_timer.start()


func _on_ears_timer_timeout() -> void:
	animations.idle(state.facing_direction)
	_wait_timer.start()


func _is_action_active() -> bool:
	return state.action ==  &'Idle'
