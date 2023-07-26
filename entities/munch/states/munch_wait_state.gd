extends State

@export
var wait_timer: Timer


func _ready() -> void:
	wait_timer.timeout.connect(on_wait_timer_timeout)


func begin(_kwargs := {}) -> void:
	wait_timer.start()


func on_wait_timer_timeout() -> void:
	state_machine.transition_to(&'Scatter')
