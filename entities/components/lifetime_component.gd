@icon('res://editor/icons/lifetime.png')
class_name LifetimeComponent
extends Node

@export
var entity: Entity

var has_lifetime: bool:
	get: return entity.properties.lifetime > 0

var is_running: bool:
	get: return not _duration_timer.is_stopped()

var _duration_timer: Timer


func _ready() -> void:
	_create_duration_timer()
	_start_lifetime()


func _create_duration_timer() -> void:
	_duration_timer = Timer.new()
	_duration_timer.process_callback = Timer.TIMER_PROCESS_PHYSICS
	_duration_timer.one_shot = true
	_duration_timer.timeout.connect(_on_duration_timer_timeout)
	add_child(_duration_timer, false, Node.INTERNAL_MODE_BACK)


func _start_lifetime() -> void:
	if has_lifetime:
		_duration_timer.start(entity.properties.lifetime)


func _process(_delta: float) -> void:
	var timer_active = not _duration_timer.is_stopped()
	var is_player = entity.is_in_group(Entity.Group.PLAYER)
	
	if timer_active and is_player:
		Events.player_roll_ticked.emit(int(_duration_timer.time_left))


func _on_duration_timer_timeout() -> void:
	if entity.is_player_ability():
		entity.wear_off_roll()
