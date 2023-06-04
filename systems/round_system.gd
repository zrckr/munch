class_name RoundSystem
extends Node

@export
var rounds: Array[Round]

@onready
var duration_timer: Timer = $DurationTimer

##
var _current_round: Round

##
var _current_round_index := -1

##
var _current_spawn_queue := []


func _enter_tree() -> void:
	get_tree().process_frame.connect(_on_process_frame)


func _on_process_frame() -> void:
	if not _current_spawn_queue.is_empty():
		var entity = _current_spawn_queue.pop_front()
		get_tree().current_scene.add_child(entity, true)
	
	if duration_timer and not duration_timer.is_stopped():
		var time_left = int(duration_timer.time_left)
		Events.round_ticked.emit(time_left)


func _exit_tree() -> void:
	get_tree().process_frame.disconnect(_on_process_frame)


func start_next_round() -> void:
	var next_round_index = clampi(_current_round_index + 1, 0, len(rounds)-1)
	var next_round = rounds[next_round_index]
	
	if next_round != _current_round:
		_current_round = next_round
		_current_round_index = next_round_index
		assert(_current_round, 'The round is not defined')
	
	duration_timer.start(_current_round.duration)
	Events.round_ticked.emit(_current_round.duration)
	Events.round_started.emit()
	
	get_tree().node_removed.connect(_on_node_removed)
	_queue_player_to_spawn()
	
	for i in range(_current_round.max_munchies):
		_queue_munch_to_spawn()
	
	for group in _current_round.groups:
		for unit in group.units:
			var quantity = randi_range(unit.min_quantity, unit.max_quantity)
			for i in range(quantity):
				_queue_entity_to_spawn(group, unit, group.respawn_time)


func end_current_round() -> void:
	get_tree().node_removed.disconnect(_on_node_removed)
	duration_timer.stop()
	Events.round_failed.emit()


func _queue_player_to_spawn(wait_to_spawn := 0.0) -> void:
	if wait_to_spawn > 0:
		var wait_timer = get_tree().create_timer(wait_to_spawn, false, true)
		await wait_timer.timeout
	
	var player = Game.get_summon().spawn_player()
	_current_spawn_queue.push_front(player)


func _queue_munch_to_spawn(wait_to_spawn := 0.0) -> void:
	if wait_to_spawn > 0:
		var wait_timer = get_tree().create_timer(wait_to_spawn, false, true)
		await wait_timer.timeout
	
	var munch = Game.get_summon().spawn_munch()
	_current_spawn_queue.push_front(munch)


func _queue_entity_to_spawn(
	group: RoundGroup,
	unit: RoundUnit,
	wait_to_spawn := 0.0
) -> void:
	if wait_to_spawn > 0:
		var wait_timer = get_tree().create_timer(wait_to_spawn, false, true)
		await wait_timer.timeout
	
	var position_type = (
		group.override_position_type if group.override_enabled
		else unit.position_type
	)
	
	var groups = [group.resource_name, unit.resource_name]
	
	var entity = Game.get_summon() \
		.spawn_entity(unit.entity_scene, position_type, groups)
	
	_current_spawn_queue.push_front(entity)


func _on_node_removed(node: Node) -> void:
	if not Game.is_known_group(node):
		return
	
	if node.is_in_group(Game.Groups.MUNCHIES):
		_queue_munch_to_spawn(3.0) 	# TODO: export this variable
		return
	
	if node.is_in_group(Game.Groups.ENEMIES):
		for group in _current_round.groups:
			for unit in group.units:
				var same_group = node.is_in_group(group.resource_name)
				var same_node = node.is_in_group(unit.resource_name)
			
				if same_group and same_node:
					_queue_entity_to_spawn(group, unit, group.respawn_time)


func _on_duration_timer_timeout() -> void:
	Events.round_succesed.emit()
	Game.get_player().queue_free()
