extends Node2D

var _entity: Entity:
	get:
		assert(owner is Entity, 'The [%s] is not an Entity' % owner.name)
		return owner as Entity

@export
var bullet_projectile: PackedScene

@export_flags_2d_physics
var bullet_collision_layer: int

@export_flags_2d_physics
var bullet_collision_mask: int

@onready
var _muzzle_marker: Marker2D = $MuzzleMarker


func _input(event: InputEvent) -> void:
	if event.is_action_pressed('attack'):
		await get_tree().physics_frame
		_spawn_projectile_instance()


func _spawn_projectile_instance() -> void:
	var projectile = bullet_projectile.instantiate() as Projectile
	
	projectile.collision_layer = bullet_collision_layer
	projectile.collision_mask = bullet_collision_mask
	projectile.transform = _muzzle_marker.global_transform
	
	if get_tree().current_scene == _entity:
		get_tree().root.add_child(projectile)
	else:
		get_tree().current_scene.add_child(projectile)
