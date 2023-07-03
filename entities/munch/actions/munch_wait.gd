extends EntityAction

@onready
var _wait_timer: Timer = $WaitTimer


func _begin() -> void:
	_wait_timer.start()


func _is_action_active() -> bool:
	return state.action == &'Wait'


func _on_wait_timer_timeout() -> void:
	state.action = &'Scatter'
