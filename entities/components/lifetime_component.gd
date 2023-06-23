@icon('res://editor/icons/lifetime.png')
class_name LifetimeComponent
extends Node

const INFINITE_LIFETIME := -1

var _entity: Entity:
	get: return owner as Entity

var _properties: EntityProperties:
	get: return _entity.properties

@onready
var _duration_timer: Timer = $DurationTimer


func _ready() -> void:
	_start_lifetime()
	Events.round_started.connect(_on_round_started)
	Events.round_failed.connect(_on_round_failed)


func _process(_delta: float) -> void:
	if not _duration_timer.is_stopped():
		_emit_roll_ticked_event(_duration_timer.time_left)


func _serialize(state: EntityState) -> void:
	if _duration_timer:
		state.duration_time = _duration_timer.time_left


func _deserialize(state: EntityState) -> void:
	if _duration_timer:
		_duration_timer.start(state.duration_time)


func _start_lifetime() -> void:
	var not_zero := _properties.lifetime != 0
	var not_infinite = _properties.lifetime != INFINITE_LIFETIME
	
	if not_zero and not_infinite:
		_duration_timer.start(_properties.lifetime)


func _emit_roll_ticked_event(time_left: float) -> void:
	if _entity.is_in_group(Entity.Group.PLAYER):
		Events.player_roll_ticked.emit(int(time_left))


func _on_duration_timer_timeout() -> void:
	_entity.wear_off_roll()


func _on_round_started() -> void:
	push_error('Method not implemented')


func _on_round_failed() -> void:
	push_error('Method not implemented')
