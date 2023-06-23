@icon('res://editor/icons/movement.png')
class_name MovementComponent
extends Node

var _entity: Entity:
	get: return owner as Entity

var _properties: EntityProperties:
	get: return _entity.properties

var facing_direction: Vector2i:
	get:
		return Vector2i(_current_direction.round())

var knockback_direction: Vector2i:
	get:
		return Vector2i(_knockback_direction.round())

var _current_speed: float

var _current_direction: Vector2

var _is_knockbacked: bool

var _knockback_direction: Vector2


func _enter_tree() -> void:
	if _entity.motion_mode != CharacterBody2D.MOTION_MODE_FLOATING:
		push_error('Set the motion mode to `Floating` for [%s]' % owner.name)
	
	_current_speed = _properties.speed
	_current_direction = Vector2.ZERO


func _serialize(state: EntityState) -> void:
	state.transform = _entity.global_transform
	state.direction = _current_direction
	state.speed = _current_speed


func _deserialize(state: EntityState) -> void:
	_entity.global_transform = state.transform
	_current_direction = state.direction
	_current_speed = state.speed


func enable() -> void:
	if not is_physics_processing():
		set_physics_process(true)


func disable() -> void:
	if is_physics_processing():
		set_physics_process(false)


func start_knockback(direction: Vector2, strength: float) -> void:
	_is_knockbacked = true
	_knockback_direction = direction
	while _is_knockbacked and is_physics_processing():
		await get_tree().physics_frame
		_entity.velocity = direction * strength
		_entity.move_and_slide()


func end_knockback() -> void:
	_is_knockbacked = false
