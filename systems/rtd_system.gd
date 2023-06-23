class_name RtdSystem
extends System

@export
var abilities: EntityAbilities:
	get: return abilities

var _positive_queue: Array[PackedScene]:
	get:
		if _positive_queue.is_empty():
			_positive_queue.append_array(abilities.positive_abilities)
			_positive_queue.shuffle()
		return _positive_queue

var _negative_queue: Array[PackedScene]:
	get:
		if _negative_queue.is_empty():
			_negative_queue.append_array(abilities.negative_abilities)
			_negative_queue.shuffle()
		return _negative_queue

var _current_chance: int


func _ready() -> void:
	_current_chance = abilities.default_chance


func _enter_tree():
	get_tree().node_added.connect(_on_node_added)


func _exit_tree() -> void:
	get_tree().node_removed.connect(_on_node_added)


func _process(_delta: float) -> void:
	for entity in get_tree().get_nodes_in_group(Entity.Group._ROLL_THE_DICE):
		entity.remove_from_group(Entity.Group._ROLL_THE_DICE)
		_roll_the_dice(entity)
		entity.queue_free()
	
	for entity in get_tree().get_nodes_in_group(Entity.Group._WEAR_OFF_ROLL):
		entity.remove_from_group(Entity.Group._WEAR_OFF_ROLL)
		_back_to_default(entity)
		entity.queue_free()


func _input(_event: InputEvent) -> void:
	if OS.is_debug_build():
		if Input.is_physical_key_pressed(KEY_F1):
			print('[RTD] Only the positive rolls will be used')
			_current_chance = EntityAbilities.ALWAYS_POSITIVE_ABILITIES_CHANCE
		
		if Input.is_physical_key_pressed(KEY_F2):
			print('[RTD] Only the negative rolls will be used')
			_current_chance = EntityAbilities.ALWAYS_NEGATIVE_ABILITIES_CHANCE
		
		if Input.is_physical_key_pressed(KEY_F3):
			print('[RTD] Reset to default roll chance')
			_current_chance = abilities.default_chance


func _roll_the_dice(entity: Entity) -> void:
	var random_ability = _choose_random_ability(_current_chance)
	var random_properties = random_ability.properties
	
	random_ability.state = entity.state
	random_ability.add_to_group(entity.properties.entity_group)
	
	get_tree().current_scene.add_child(random_ability)
	Events.player_rolled_the_dice.emit(random_properties)


func _back_to_default(entity: Entity) -> void:
	var default_ability = _choose_default_ability()
	var default_properties = default_ability.properties
	
	default_ability.state = entity.state
	
	get_tree().current_scene.add_child(default_ability)
	Events.player_roll_worn_off.emit(default_properties)


func _choose_random_ability(chance: int) -> Entity:
	var roll_positive = (chance / 100.0) > randf()
	
	var selected_abilities = (
		_positive_queue if roll_positive
		else _negative_queue
	)
	
	var packed_scene = selected_abilities.pop_front()
	var entity = packed_scene.instantiate() as Entity
	return entity as Entity


func _choose_default_ability() -> Entity:
	var entity = abilities.default_ability.instantiate()
	return entity as Entity


func _on_node_added(node: Node) -> void:
	if node is Entity and node.is_player_default():
		Events.player_roll_worn_off.emit(node.properties)
		return
	
	if node is MunchboxComponent:
		node._munchies_total = abilities.activation_threshold
		return
