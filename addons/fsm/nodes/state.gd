## Abstract class. Extend it to create own states.
## A [State] can be attached to a [StateMachine] by adding it as a child node to the [StateMachine] node.
@icon("../icons/state.svg")
class_name State
extends Node

## If [code]true[/code], this state will not be processed by the state machine.
@export
var disabled := false:
	get:
		return disabled
	set(value):
		disabled = value
		_was_active = not value
		set_physics_process(not value)

## Reference to the state machine. Use inside state classes to
## transition between states.
var state_machine: StateMachine

var _was_active := false


func _physics_process(delta: float) -> void:
	transition_attempts()
	var is_active = is_state_active(state_machine.current_state)
	
	if is_active:
		if not _was_active:
			var kwargs = state_machine.consume_kwargs(name)
			begin(kwargs)
		else:
			act(delta)
	elif _was_active:
		end()
	
	_was_active = is_active


func _notification(what: int) -> void:
	match what:
		NOTIFICATION_READY:
			if not Engine.is_editor_hint() and is_inside_tree():
				set_physics_process(not disabled)


## Used by [StateMachine] every process frame to
## perform a transition to this state.
func transition_attempts() -> void:
	pass


## Used by [StateMachine] to enter this state.
func begin(_kwargs := {}) -> void:
	pass


## Used by [StateMachine] to tick this state.
func act(_delta: float) -> void:
	pass


## Used by [StateMachine] to exit this state.
func end() -> void:
	pass


## Used by [StateMachine] to evaluate this state.
func is_state_active(current_state: State) -> bool:
	return current_state == self
