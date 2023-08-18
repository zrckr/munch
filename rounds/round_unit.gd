class_name RoundUnit
extends Resource

@export
var position_type: RandomPositioner.Type

@export
var entity_scene: PackedScene

@export_range(1, 1000, 1)
var min_quantity := 1

@export_range(1, 1000, 1)
var max_quantity := 1
