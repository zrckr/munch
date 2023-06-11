class_name RoundSystem
extends System

@export_group("Rounds Properties")
@export var rounds: Array[Round]
@export var min_position: Vector2
@export var max_position: Vector2

@export_group('Entity Scenes', 'entity_scene_')
@export var entity_scene_player: PackedScene
@export var entity_scene_munch: PackedScene
@export var entity_scene_spawner: PackedScene

@export_group('Munchies Properties', 'munchies_')
@export_range(1, 1000, 1, 'suffix:px') var munchies_spawn_radius: int
@export_range(1, 60, 1, 'suffix:seconds') var munchies_respawn_time: int

var _current_round: Round:
	get: return rounds[_current_round_index]

var _current_round_index := -1

var _entity_spawn_queue := []

@onready
var _duration_timer: Timer = $DurationTimer


func _process(_delta: float) -> void:
	for entity in _entity_spawn_queue.duplicate():
		_entity_spawn_queue.pop_front()
		get_tree().current_scene.call_deferred('add_child', entity, true)
	
	if not _duration_timer.is_stopped():
		var time_left = int(_duration_timer.time_left)
		Events.round_ticked.emit(time_left)


func start_next_round() -> void:
	_current_round_index = clampi(_current_round_index + 1, 0, len(rounds)-1)
	_duration_timer.start(_current_round.duration)
	
	_queue_player_to_spawn()
	_queue_munchies_to_spawn()
	_queue_enemies_to_spawn()
	
	get_tree().node_removed.connect(_on_node_removed)


func end_current_round() -> void:
	get_tree().node_removed.disconnect(_on_node_removed)
	_duration_timer.stop()


func _queue_player_to_spawn() -> void:
	var positioner = Positioner.new() \
		.set_min_position(min_position) \
		.set_max_position(max_position) \
		.set_edge_offset(Math.QUADRUPLE)
	
	var player_entity = entity_scene_player.instantiate() as Entity
	player_entity.global_position = positioner.get_center_of_box()
	
	_queue_node_to_spawn(player_entity)


func _queue_munchies_to_spawn() -> void:
	for i in range(_current_round.max_munchies):
		_queue_one_munch_to_spawn()


func _queue_one_munch_to_spawn(spawn_time := 0) -> void:
	var positioner = Positioner.new() \
		.set_min_position(min_position) \
		.set_max_position(max_position) \
		.set_edge_offset(Math.QUADRUPLE)
	
	var start_position = positioner.get_center_of_box()
	
	var munch_entity = entity_scene_munch.instantiate() as Entity
	munch_entity.global_position = positioner \
		.get_random_inside_area(start_position, munchies_spawn_radius)
		
	_queue_node_to_spawn(munch_entity, spawn_time)


func _queue_enemies_to_spawn() -> void:
	for group in _current_round.groups:
		for unit in group.units:
			var quantity = randi_range(unit.min_quantity, unit.max_quantity)
			for i in range(quantity):
				_queue_enemy_to_spawn(group, unit)


func _queue_enemy_to_spawn(group: RoundGroup, unit: RoundUnit, spawn_time := 0) -> void:
	var groups = [group.resource_name, unit.resource_name]
	
	var positioner = Positioner.new() \
		.set_min_position(min_position) \
		.set_max_position(max_position) \
		.set_edge_offset(Math.DOUBLE)
	
	var position_type = (
		group.override_position_type if group.override_enabled
		else unit.position_type
	)
	
	var spawner = entity_scene_spawner.instantiate() as Spawner
	spawner.entity_scene = unit.entity_scene
	spawner.entity_groups = groups
	spawner.global_position = positioner.get_random_by_type(position_type)
	
	_queue_node_to_spawn(spawner, spawn_time)


func _queue_node_to_spawn(node: Node, spawn_time := 0) -> void:
	if spawn_time > 0:
		var wait_timer = get_tree().create_timer(spawn_time, false, true)
		await wait_timer.timeout
	
	_entity_spawn_queue.push_front(node)


func _on_node_removed(node: Node) -> void:
	if node.is_in_group(Entity.Group.MUNCH):
		_queue_one_munch_to_spawn(munchies_respawn_time)
		return
	
	if node.is_in_group(Entity.Group.ENEMY):
		for group in _current_round.groups:
			for unit in group.units:
				if node.is_in_group(group.resource_name) and \
					node.is_in_group(unit.resource_name):
					_queue_enemy_to_spawn(group, unit, group.respawn_time)
