extends EntityAction

const INFINITE_LIFETIME := -1

@onready
var _duration_timer: Timer = $DurationTimer


func _ready() -> void:
	await entity.ready
	state.action = &'Idle'
	_setup_duration()
	_setup_health()


func _act(_delta: float) -> void:
	if not _duration_timer.is_stopped():
		var time_left = int(_duration_timer.time_left)
		Events.player_roll_ticked.emit(time_left)


func _is_action_active() -> bool:
	return true


func _on_duration_timer_timeout() -> void:
	if entity.is_player_ability():
		entity.wear_off_roll()


func _setup_duration() -> void:
	var not_empty = properties.lifetime != 0
	var not_infinite = properties.lifetime != INFINITE_LIFETIME
	if not_empty and not_infinite:
		_duration_timer.start(properties.lifetime)


func _setup_health() -> void:
	state.health_points = properties.health_points
