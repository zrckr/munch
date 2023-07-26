@tool
@icon('res://editor/icons/entity.png')
class_name Entity
extends CharacterBody2D

const Group := {
	# Common
	PLAYER = 'player',
	ENEMY = 'enemy',
	MUNCH = 'munch',
	# RTD
	POSITIVE_ROLL = 'positive_roll',
	NEGATIVE_ROLL = 'negative_roll',
	# Internal
	_ROLL_THE_DICE = '_roll_the_dice',
	_WEAR_OFF_ROLL = '_wear_off_roll',
}

@export
var properties: EntityProperties


func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray = []
	
	if not properties:
		warnings.append("The properties resource for this entity is not defined.")
	
	if motion_mode != MOTION_MODE_FLOATING:
		warnings.append("Set the motion mode to 'Floating'.")
	
	return warnings


func _ready() -> void:
	if Engine.is_editor_hint():
		return
	
	if properties:
		add_to_group(properties.entity_group)
	
	if not _is_any_group():
		push_error('You forgot to add [%s] to one of these groups: %s' % \
			[get_path(), str(Group.values())])


func roll_the_dice() -> void:
	if not _is_ability():
		add_to_group(Group._ROLL_THE_DICE)


func wear_off_roll() -> void:
	if _is_ability():
		add_to_group(Group._WEAR_OFF_ROLL)


func is_player_ability() -> bool:
	return is_in_group(Group.PLAYER) and _is_ability()


func is_player_default() -> bool:
	return is_in_group(Group.PLAYER) and not _is_ability()


func _is_any_group() -> bool:
	var result = false
	for group in Group.values():
		result = result or is_in_group(group)
	return result


func _is_ability() -> bool:
	return is_in_group(Entity.Group.POSITIVE_ROLL) or \
			is_in_group(Entity.Group.NEGATIVE_ROLL)
