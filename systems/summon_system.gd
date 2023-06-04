class_name SummonSystem
extends Node

@export
var player_scene: PackedScene

@export
var munch_scene: PackedScene

@export
var munch_spawn_area_radius: float

@export
var spawner_scene: PackedScene

##
var min_position: Vector2

##
var max_position: Vector2


func _physics_process(_delta: float) -> void:
	var enemies = get_tree().get_nodes_in_group(Game.Groups.ENEMIES)
	for i in range(len(enemies)):
		enemies[i].collision_priority = float(i + 1)


func spawn_player() -> Node2D:
	var start_position = Positioner.new() \
		.set_min_position(min_position) \
		.set_max_position(max_position) \
		.get_center_of_box()
	
	var player_instance := player_scene.instantiate() as Node2D
	player_instance.global_position = start_position
	
	return player_instance


func spawn_munch() -> Node2D:
	var positioner = Positioner.new() \
		.set_min_position(min_position) \
		.set_max_position(max_position) \
		.set_edge_offset(Math.QUADRUPLE)
	
	var start_position = positioner.get_center_of_box()
	var munch_instance := munch_scene.instantiate() as Node2D
	
	munch_instance.positioner = positioner
	munch_instance.global_position = positioner \
		.get_random_inside_area(start_position, munch_spawn_area_radius)
	
	return munch_instance


func spawn_entity(
	scene: PackedScene,
	position_type: Positioner.Type,
	groups: Array
) -> Node2D:
	var positioner = Positioner.new() \
		.set_min_position(min_position) \
		.set_max_position(max_position) \
		.set_edge_offset(Math.DOUBLE)
	
	var position = positioner.get_random_by_type(position_type)
	var spawner_instance := spawner_scene.instantiate() as Node2D
	
	spawner_instance.entity_scene = scene
	spawner_instance.entity_groups = groups
	spawner_instance.global_position = position
	
	return spawner_instance
