class_name HealthComponent
extends Node

const INFINITE_HEALTH_POINTS := -1

var _entity: Entity:
	get:
		assert(owner is Entity, 'The [%s] is not an Entity' % owner.name)
		return owner as Entity

var _properties: EntityProperties:
	get:
		assert(_entity.properties, 'No EntityProperties present for [%s]' % owner.name)
		return _entity.properties

var _health_points: int:
	get:
		return _health_points
	set(value):
		_health_points = value
		_emit_health_updated_event(value)

var _is_invulnerable_to_attacks: bool

@onready
var _invincibility_timer: Timer = $InvincibilityTimer

@onready
var _stun_timer: Timer = $StunTimer


func _enter_tree() -> void:
	# Fallback values
	_health_points = _properties.health_points
	_is_invulnerable_to_attacks = false


func _serialize(state: EntityState) -> void:
	state.health_points = _health_points
	state.is_invulnerable = _is_invulnerable_to_attacks


func _deserialize(state: EntityState) -> void:
	match _properties.health_type:
		EntityProperties.HealthType.SET_HEALTH_FOR_NEW_ABILITY:
			_health_points = _properties.health_points
			_is_invulnerable_to_attacks = state.is_invulnerable

		EntityProperties.HealthType.USE_HEALTH_FROM_PREVIOUS_ABILITY:
			_health_points = state.health_points
			_is_invulnerable_to_attacks = state.is_invulnerable

		EntityProperties.HealthType.INVULNERABLE_TO_ATTACKS:
			_health_points = INFINITE_HEALTH_POINTS
			_is_invulnerable_to_attacks = true


func take_damage(damage_points: int) -> void:
	if not _is_invulnerable_to_attacks:
		_health_points -= damage_points
		_stun_timer.start()


func _make_entity_dead() -> void:
	_entity.movement_component.disable()
	_emit_died_event()
	
	await _entity.animation_component.play_defeated_async()
	_entity.queue_free()


func _emit_health_updated_event(value: int) -> void:
	if _entity.is_in_group(Entity.Group.PLAYER):
		Events.player_health_updated.emit(value)


func _emit_died_event() -> void:
	if _entity.is_in_group(Entity.Group.PLAYER):
		Events.player_died.emit()
	elif _entity.is_in_group(Entity.Group.ENEMY):
		Events.enemy_died.emit(_entity)


func _on_stun_timer_timeout() -> void:
	_entity.animation_component.reset_sprite_modulation()
	_entity.movement_component.end_knockback()
	
	if _health_points > 0:
		_invincibility_timer.start()
		_entity.animation_component \
			.blink_sprite(_invincibility_timer.wait_time)
	else:
		_make_entity_dead()


func _on_invincibility_timer_timeout() -> void:
	_entity.hurtbox_component.enable()
