class_name EntityProperties
extends Resource

@export var display_name := 'Untitled'
@export var lifetime := -1

@export_group('Health', 'health_')
@export var health_use_previous_value := false
@export_range(1, 100, 1, 'suffix:hp') var health_value := 1
@export_range(1, 100, 1, 'suffix:hp') var health_overheal := 3

@export_group('Damage', 'damage_')
@export_range(0, 100, 1, 'suffix:dp') var damage_value := 0
@export_range(0, 100, 1, 'suffix:dp') var damage_cap := 0

@export_group('Movement', 'speed_')
@export_range(0, 400, 5, 'suffix:px/s') var speed_value := 4.0
@export_range(0, 400, 5, 'suffix:px/s') var speed_cap := 4.0
