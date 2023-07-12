@icon('res://editor/icons/node.png')
class_name EntityState
extends CanvasItem

signal action_changed(previous, next)

@export
var initial_action: EntityAction

@onready
var entity := owner as Entity:
	get: return entity

var action: StringName:
	get: return _actions_stack.front()
	set(value): transition_to(value)

var last_action: StringName:
	get: return _actions_stack[1] if len(_actions_stack) > 1 else &''

var _actions_stack: Array[StringName] = [&'']:
	get: return _actions_stack


func _ready() -> void:
	if not initial_action:
		push_warning('Initial action is not defined for %s' % entity.name)
	else:
		transition_to(initial_action.name)


func transition_to(next_action: StringName) -> void:
	if next_action != action:
		var previous_action = action
		_actions_stack[0] = next_action
		action_changed.emit(previous_action, next_action)


func transition_queue(next_action: StringName) -> void:
	if next_action != action:
		var previous_action = action
		_actions_stack.push_front(next_action)
		action_changed.emit(previous_action, next_action)


func transition_back() -> void:
	if len(_actions_stack) < 2:
		push_error('There are no previous actions in the stack in the %s' % entity.name)
		return
	
	var previous_action = action
	_actions_stack.pop_front()
	action_changed.emit(previous_action, action)


func reset() -> void:
	_actions_stack.clear()
