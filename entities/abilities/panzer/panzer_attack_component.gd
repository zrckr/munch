@icon('res://editor/icons/hitbox.png')
class_name PanzerAttackComponent
extends Area2D

enum State {
	RELOADING,
	READY,
}

var _entity: Entity:
	get: return owner as Entity

var _properties: EntityProperties:
	get: return _entity.properties

@export
var bullet_projectile: PackedScene

@export_flags_2d_physics
var bullet_collision_layer: int

@export_flags_2d_physics
var bullet_collision_mask: int

var _state: State:
	get:
		return _state
	set(value):
		_state = value
		_process_attack(value)

var _current_target_entities := []

var _entities_in_range := []

@onready
var _muzzle_marker: Marker2D = $MuzzleMarker

@onready
var _reload_timer: Timer = $ReloadTimer


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed('attack'):
		call_deferred('_spawn_projectile_instance')
		_state = State.RELOADING


func _physics_process(_delta: float) -> void:
	var next_rotation = _get_direction_and_calculate_target()
	global_rotation = lerp_angle(global_rotation, next_rotation, 0.333)


func _process_attack(new_state: State) -> void:
	match new_state:
		State.READY:
			set_process_unhandled_input(true)
		
		State.RELOADING:
			set_process_unhandled_input(false)
			_reload_timer.start()


func _spawn_projectile_instance() -> void:
	var projectile = bullet_projectile.instantiate() as Projectile
	
	projectile.damage = _properties.damage
	projectile.collision_layer = bullet_collision_layer
	projectile.collision_mask = bullet_collision_mask
	projectile.transform = _muzzle_marker.global_transform
	
	get_viewport().add_child(projectile)


func _get_direction_and_calculate_target() -> float:
	if _entities_in_range.is_empty():
		return _entity.global_rotation
	
	_current_target_entities = _get_nearest_target(_entities_in_range, global_position)
	if _current_target_entities.is_empty():
		return _entity.global_rotation
	
	var diff = (_current_target_entities.front().global_position - global_position)
	return diff.angle() + PI / 2.0


func _on_reload_timer_timeout() -> void:
	_state = State.READY


func _on_entity_entered(entity: Entity) -> void:
	_entities_in_range.push_back(entity)
	entity.tree_exiting.connect(_on_entity_tree_exiting.bind(entity))


func _on_entity_exited(entity: Entity) -> void:
	_entities_in_range.erase(entity)
	entity.tree_exiting.disconnect(_on_entity_tree_exiting.bind(entity))
	
	if not _current_target_entities.is_empty():
		if _current_target_entities.front() == entity:
			_current_target_entities.clear()


func _on_entity_tree_exiting(entity: Entity) -> void:
	_entities_in_range.erase(entity)
	if not _current_target_entities.is_empty():
		if _current_target_entities.front() == entity:
			_current_target_entities.clear()


func _get_nearest_target(targets: Array, from: Vector2) -> Array:
	var nearest_target: = []
	
	for target in targets:
		var distance = target.global_position.distance_to(from)
		var is_between = Math.betweenf(distance, 0, 1000)
		var is_nearest = nearest_target.is_empty() or distance < nearest_target[1]
		
		if is_between and is_nearest:
			nearest_target = [target, distance]
	
	return nearest_target
