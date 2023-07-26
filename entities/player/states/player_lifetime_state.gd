extends State

const INFINITE_LIFETIME := -1

@export var duration_timer: Timer

@export_group('Player Dependencies')
@export var player: Entity


func _ready() -> void:
	await player.ready
	
	var not_empty = player.properties.lifetime != 0
	var not_infinite = player.properties.lifetime != INFINITE_LIFETIME
	
	if not_empty and not_infinite:
		duration_timer.timeout.connect(on_duration_timer_timeout)
		duration_timer.start(player.properties.lifetime)


func act(_delta: float) -> void:
	if not duration_timer.is_stopped():
		var time_left = int(duration_timer.time_left)
		Events.player_roll_ticked.emit(time_left)


func on_duration_timer_timeout() -> void:
	if player.is_player_ability():
		player.wear_off_roll()


func is_action_active() -> bool:
	return true
