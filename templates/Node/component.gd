# meta-description: Template for defining entity component

@icon('res://editor/icons/component.png')
extends _BASE_

# Shortcut for accessing entity reference
var _entity: Entity:
	get:
		assert(owner is Entity, 'The [%s] is not an Entity' % owner.name)
		return owner as Entity

# Shortcut for accessing entity property resource
var _properties: EntityProperties:
	get:
		assert(_entity.properties, 'No EntityProperties present for [%s]' % owner.name)
		return _entity.properties


# Called when the state of the entity is saved in a save file
func _serialize(state: EntityState) -> void:
	pass


# Called when the state of the entity is read from a save file
func _deserialize(state: EntityState) -> void:
	pass
