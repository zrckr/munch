@icon('res://editor/icons/action.png')
class_name EntityAction
extends Node

@onready
var entity := owner as Entity:
	get: return entity

var state: EntityState:
	get: return entity.state

var properties: EntityProperties:
	get: return entity.properties

var animations: EntityAnimations:
	get: return entity.animations

var _was_active := false


func _physics_process(delta: float) -> void:
	_transition_attempts()
	var is_active = _is_action_active()
	if is_active:
		if not _was_active:
			_begin()
		else:
			_act(delta)
	elif _was_active:
		_end()
	_was_active = is_active


func _transition_attempts() -> void:
	pass


func _begin() -> void:
	pass


func _act(_delta: float) -> void:
	pass


func _end() -> void:
	pass


func _is_action_active() -> bool:
	return false
