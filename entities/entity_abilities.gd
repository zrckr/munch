class_name EntityAbilities
extends Resource

const ALWAYS_POSITIVE_ABILITIES_CHANCE := 100	# %
const ALWAYS_NEGATIVE_ABILITIES_CHANCE := 0		# %

@export_file('*.tscn') var default_scene: String
@export_range(1, 10, 1) var activation_threshold: int

@export_group('Abilities', 'abilities_')
@export var abilities_positive: Array[PackedScene]
@export var abilities_negative: Array[PackedScene]

@export_group('Chance', 'chance_')
@export_range(1, 100, 1, 'suffix:%') var chance_default: int
@export_range(1, 100, 1, 'suffix:%') var chance_minumum: int
@export_range(1, 100, 1, 'suffix:%') var chance_maximum: int


func choose_default(current_ability_instance: Node) -> PackedScene:
	if current_ability_instance.scene_file_path != default_scene:
		return load(default_scene) as PackedScene
	return null


func choose_random(chance: int, random: RandomNumberGenerator) -> PackedScene:
	chance = clampi(chance, chance_minumum, chance_maximum)
	var chance_normalized = chance / 100.0
	
	var roll_positive = chance_normalized > random.randf()
	var selected_abilities = (
		abilities_positive if roll_positive
		else abilities_negative
	)
	
	var index = random.randi() % len(selected_abilities)
	var selected_ability = selected_abilities[index]
	
	return selected_ability
