class_name RoundGroup
extends Resource

@export
var units: Array[RoundUnit]

@export_range(0, 100, 1, 'suffix:%')
var respawn_chance := 100

@export_range(1, 120, 1, 'suffix:seconds')
var respawn_time := 1

@export_group('Overrides', 'override_')

@export
var override_enabled := false

@export
var override_position_type: RandomPositioner.Type
