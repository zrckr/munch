class_name RtdSystem
extends Node

@export
var abilities: EntityAbilities

##
var munchies_eaten: int:
	get: return _munchies_eaten
	set(value):
		_munchies_eaten = value
		Events.player_munchies_eaten \
			.emit(value, abilities.activation_threshold)

##
var current_chance := 0

##
var random := RandomNumberGenerator.new()

##
var _munchies_eaten := 0


func _enter_tree() -> void:
	assert(abilities, 'The abilities is not defined')
	current_chance = abilities.chance_default
	random.randomize()


func _input(_event: InputEvent) -> void:
	if OS.is_debug_build():
		if Input.is_physical_key_pressed(KEY_F1):
			push_warning('Only the positive rolls will be used')
			current_chance = EntityAbilities.ALWAYS_POSITIVE_ABILITIES_CHANCE
		
		if Input.is_physical_key_pressed(KEY_F2):
			push_warning('Only the negative rolls will be used')
			current_chance = EntityAbilities.ALWAYS_NEGATIVE_ABILITIES_CHANCE
		
		if Input.is_physical_key_pressed(KEY_F3):
			push_warning('[RTD] Reset to default roll chance')
			current_chance = abilities.chance_default


func can_roll_the_dice(entity: Node) -> bool:
	var called_from_default = abilities.default_scene == str(entity.scene_file_path)
	var all_munchies_eaten = abilities.activation_threshold == munchies_eaten
	return called_from_default and all_munchies_eaten


func increase_roll_chance(amount: int) -> void:
	assert(Math.betweeni(amount, -100, 100), \
		'Invalid roll chance amount: %d' % amount)
	
	current_chance = clampi(
		current_chance + amount,
		abilities.chance_minumum,
		abilities.chance_maximum
	)


func lower_activation_threshold() -> void:
	munchies_eaten += 1


func roll_the_dice(entity: Node) -> void:
	var ability = abilities.choose_random(current_chance, random)
	if not ability:
		Events.player_wasted_the_roll.emit()
		return
	
	var instance = ability.instantiate()
	instance.global_position = entity.global_position
	instance.add_to_group(entity.get_groups().front())
	
	get_tree().current_scene.add_child(instance)
	Events.player_rolled_the_dice.emit(instance)


func back_to_default(entity: Node) -> void:
	munchies_eaten = 0
	
	var default = abilities.choose_default(entity)
	assert(default, 'The default ability is not defined')
	
	var instance = default.instantiate()
	instance.global_position = entity.global_position
	
	get_tree().current_scene.add_child(instance)
	Events.player_roll_worn_off.emit()
