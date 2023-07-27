@icon('res://editor/icons/health.png')
class_name HealthComponent
extends Node

@export
var entity: Entity

@export
var is_invulnerable: bool

var has_remaining_health: bool:
	get: return current_health != 0

var is_damaged: bool:
	get: return current_health != max_health

var is_dead: bool:
	get: return current_health <= 0

var max_health: int:
	get: return entity.properties.health_points

var current_health: int:
	get = _get_current_health,
	set = _set_current_health

var _current_health: int

var _previous_health: int


func _notification(what: int) -> void:
	match what:
		NOTIFICATION_READY:
			_initialize_health()


func damage(damage_points: int) -> void:
	_emit_damaged(damage_points)
	current_health -= damage_points


func heal(heal_points: int) -> void:
	current_health += heal_points


func _initialize_health() -> void:
	match entity.properties.health_type:
		EntityProperties.HealthType.SET_HEALTH_FOR_NEW_ABILITY:
			_current_health = entity.properties.health_points
		
		EntityProperties.HealthType.USE_HEALTH_FROM_PREVIOUS_ABILITY:
			_current_health = entity.properties.previous_health_points


func _get_current_health() -> int:
	return _current_health


func _set_current_health(value: int) -> void:
	_previous_health = _current_health
	var next_health = _current_health if is_invulnerable else value
		
	_current_health = clampi(next_health, 0, max_health)
	_emit_health_updated(_current_health)
		
	if not has_remaining_health:
		_emit_died()


func _emit_health_updated(value: int) -> void:
	if entity.is_in_group(Entity.Group.PLAYER):
		Events.player_health_updated.emit(value)
	
	if entity.is_in_group(Entity.Group.ENEMY):
		Events.enemy_health_updated.emit(entity, value)


func _emit_damaged(value: int) -> void:
	if entity.is_in_group(Entity.Group.PLAYER):
		Events.player_damaged.emit(value)
	
	if entity.is_in_group(Entity.Group.ENEMY):
		Events.enemy_damaged.emit(entity, value)


func _emit_died() -> void:
	if entity.is_in_group(Entity.Group.PLAYER):
		Events.player_died.emit()
	
	if entity.is_in_group(Entity.Group.ENEMY):
		Events.enemy_died.emit(entity)
