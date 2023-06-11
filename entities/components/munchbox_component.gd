class_name MunchboxComponent
extends Area2D

var _entity: Entity:
	get:
		assert(owner is Entity, 'The [%s] is not an Entity' % owner.name)
		return owner as Entity

var _properties: EntityProperties:
	get:
		assert(_entity.properties, 'No EntityProperties present for [%s]' % owner.name)
		return _entity.properties

var _munchies_eaten: int:
	get:
		return _munchies_eaten
	set(value):
		_munchies_eaten = value
		_emit_munchies_eaten_event(value)

var _munchies_total: int

@onready
var _collision_shape: CollisionShape2D = $Collision


func _serialize(state: EntityState) -> void:
	state.munchbox_total = _munchies_total
	state.munchbox_eaten = _munchies_eaten
	if _collision_shape:
		state.munchbox_enabled = not _collision_shape.disabled


func _deserialize(state: EntityState) -> void:
	_munchies_total = state.munchbox_total
	_munchies_eaten = state.munchbox_eaten
	if _collision_shape:
		_collision_shape.disabled = not state.munchbox_enabled


func enable() -> void:
	_collision_shape.set_deferred('disabled', false)


func disable() -> void:
	_collision_shape.set_deferred('disabled', true)


func _emit_munchies_eaten_event(value: int) -> void:
	if _entity.is_in_group(Entity.Group.PLAYER):
		Events.player_munchies_eaten.emit(value, _munchies_total)


func _on_area_entered(munch_hitbox: HitboxComponent) -> void:
	munch_hitbox.disable()
	munch_hitbox.entity_queue_free()
	
	_munchies_eaten += 1
	if _munchies_eaten >= _munchies_total:
		_entity.roll_the_dice()
