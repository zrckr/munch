class_name MovementComponent
extends Node

var _entity: Entity:
	get:
		assert(owner is Entity, 'The [%s] is not an Entity' % owner.name)
		return owner as Entity

var _properties: EntityProperties:
	get:
		assert(_entity.properties, 'No EntityProperties present for [%s]' % owner.name)
		return _entity.properties

var facing_direction: Vector2i:
	get:
		return Vector2i(_current_direction.round())

var _current_speed: float

var _current_direction: Vector2

var _is_knockbacked: bool


func _enter_tree() -> void:
	assert(_entity.motion_mode == CharacterBody2D.MOTION_MODE_FLOATING,
		'Set the motion mode to `Floating` for [%s]' % owner.name)
	
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
	while _is_knockbacked and is_physics_processing():
		await get_tree().physics_frame
		_entity.velocity = direction * strength
		_entity.move_and_slide()


func end_knockback() -> void:
	_is_knockbacked = false
