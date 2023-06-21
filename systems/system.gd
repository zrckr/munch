@icon('res://editor/icons/system.png')
class_name System
extends Node

const Group := {
	RTD = 'rtd_system',
	ROUND = 'round_system',
}


func _enter_tree() -> void:
	assert(_is_any_group(), 'You forgot to add [%s] to one of these groups: %s' % \
		[get_path(), str(Group.values())])


func _is_any_group() -> bool:
	var result = false
	for group in Group.values():
		result = result or is_in_group(group)
	return result
