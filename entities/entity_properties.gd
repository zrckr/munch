class_name EntityProperties
extends Resource

enum HealthType {
	SET_HEALTH_FOR_NEW_ABILITY,
	USE_HEALTH_FROM_PREVIOUS_ABILITY,
	INVULNERABLE_TO_ATTACKS,
}

@export
var display_name := 'Untitled'

## NOTE: Keep it sync with the `Entity.Group` dictionary
@export_enum('player', 'enemy', 'munch', 'positive_roll', 'negative_roll')
var entity_group := ''

@export_range(-1, 600, 1, 'suffix:seconds')
var lifetime := -1

@export_range(-1, 100, 1)
var health_points := 1

@export
var health_type: HealthType

@export_range(0, 100, 1, 'suffix:dp')
var damage := 0

@export_range(0, 400, 1, 'suffix:px/s')
var speed := 4.0

@export
var extra := {}
