@icon('res://editor/icons/hitbox.png')
class_name CollisionBox
extends Area2D

var entity: Entity:
	get: return owner as Entity

var properties: EntityProperties:
	get: return entity.properties

@onready
var _collision_shape: Node = $CollisionShape


func _ready() -> void:
	var is_shape = _collision_shape is CollisionShape2D
	var is_polygon = _collision_shape is CollisionPolygon2D
	
	if not (is_shape or is_polygon):
		push_error("'%s' must be either CollisionShape2D or CollisionPolygon2D" % \
			_collision_shape.get_path())


func enable() -> void:
	_collision_shape.set_deferred('disabled', false)


func disable() -> void:
	_collision_shape.set_deferred('disabled', true)
