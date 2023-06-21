@icon('res://editor/icons/resource.png')
class_name EntityAbilities
extends Resource

## %
const ALWAYS_POSITIVE_ABILITIES_CHANCE := 100

## %
const ALWAYS_NEGATIVE_ABILITIES_CHANCE := 0

@export_range(1, 10, 1) var activation_threshold: int

@export_group('Abilities')
@export var default_ability: PackedScene
@export var positive_abilities: Array[PackedScene]
@export var negative_abilities: Array[PackedScene]

@export_group('Chance')
@export_range(1, 100, 1, 'suffix:%') var default_chance: int
@export_range(1, 100, 1, 'suffix:%') var minumum_chance: int
@export_range(1, 100, 1, 'suffix:%') var maximum_chance: int
