class_name HitboxComponent
extends Area2D

var _entity: Entity:
	get:
		assert(owner is Entity, 'The [%s] is not an Entity' % owner.name)
		return owner as Entity

var _properties: EntityProperties:
	get:
		assert(_entity.properties, 'No EntityProperties present for [%s]' % owner.name)
		return _entity.properties

var damage: int

@onready
var _collision_shape: CollisionShape2D = $Collision


func _enter_tree() -> void:
	damage = _properties.damage


func _serialize(state: EntityState) -> void:
	state.hitbox_damage = damage
	if _collision_shape:
		state.hitbox_enabled = not _collision_shape.disabled


func _deserialize(state: EntityState) -> void:
	damage = state.hitbox_damage
	if _collision_shape:
		_collision_shape.disabled = not state.hitbox_enabled


func enable() -> void:
	_collision_shape.set_deferred('disabled', false)


func disable() -> void:
	_collision_shape.set_deferred('disabled', true)


func entity_queue_free() -> void:
	if not _entity.is_queued_for_deletion():
		_entity.queue_free()
