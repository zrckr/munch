class_name Movement
extends Node

@export
var properties: EntityProperties

##
var direction := Vector2.DOWN

##
var speed := 0.0

##
var transform: Transform2D:
	get: return get_parent().global_transform
	set(value): get_parent().global_transform = value

##
var character: CharacterBody2D:
	get: return get_parent() as CharacterBody2D
	

func _enter_tree() -> void:
	assert(properties, \
		'No properties present for %s' % get_path())
	
	assert(character, \
		'The parent is not a CharacterBody2D: %s' % get_parent().get_path())
	
	assert(character.motion_mode == CharacterBody2D.MOTION_MODE_FLOATING, \
		'Set motion mode to \'Floating\' for %s' % get_parent().get_path())
	
	speed = properties.speed_value


func _serialize(state: EntityState) -> void:
	state.transform = transform
	state.direction = direction
	state.speed = speed


func _deserialize(state: EntityState) -> void:
	transform = state.transform
	direction = state.direction
	speed = state.speed


func apply_speed_factor(factor: float) -> void:
	if properties:
		speed = properties.speed_default * factor
		speed = min(speed, properties.speed_cap)
