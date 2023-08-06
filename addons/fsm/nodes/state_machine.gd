## Manages the transition and delegation of states.
## To use a [StateMachine] on a [Node] just add [StateMachine] as a child node.
## To add states to the [StateMachine] extend the [State] class,
## and add your states as child nodes to the [StateMachine] node.
@tool
@icon("../icons/state_machine.svg")
class_name StateMachine
extends Node

## Emitted when the transition to a new state is done successfully.
## Contains the [member Node.name] of the target node of the transition.
signal transitioned(previous_state_name, current_state_name)

## Points to the node representing the inital active state.
@export
var initial_state := NodePath():
	get:
		return initial_state
	set(value):
		initial_state = value
		update_configuration_warnings()

## The current state.
var current_state: State:
	get:
		return states.front()

## The states stack.
var states: Array[State] = [null]:
	get:
		return states

var _state_kwargs := {}


func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray = []
	
	if not has_node(initial_state):
		warnings.append("The initial state for this state machine is not defined.")
		
	if get_children().filter(func(x): return x is State).size() < 2:
		warnings.append("The state machine should have at least two States. Otherwise it is not useful.")
	
	return warnings


func _ready() -> void:
	if Engine.is_editor_hint():
		return
	
	if not has_node(initial_state):
		push_warning("The initial state for this state machine is not defined.")
	else:
		states[0] = get_node(initial_state)
	
	await owner.ready
	for child in get_children():
		if child is State:
			child.state_machine = self


## Provides kwargs for provided state to consume.
func consume_kwargs(state_name: StringName) -> Dictionary:
	if not _state_kwargs.has(state_name):
		return {}
	
	var kwargs = _state_kwargs[state_name]
	_state_kwargs.erase(state_name)
	return kwargs


## Replaces the front current state with new one via its name [param state_name].
## Optionally, takes a [param kwargs] dictionary to pass data to the state.
func transition_to(state_name: StringName, kwargs := {}) -> void:
	if states.is_empty():
		transition_queue(state_name, kwargs)
		return
	
	var previous_state_name = current_state.name
	states.pop_front()
	states.push_front(get_node(NodePath(state_name)))
	
	transitioned.emit(previous_state_name, state_name)
	_state_kwargs[state_name] = kwargs


## Pushes down the front current state with new one via its name [param state_name].
## Optionally, takes a [param kwargs] dictionary to pass data to the state.
func transition_queue(state_name: StringName, kwargs := {}) -> void:
	var previous_state_name = current_state.name
	states.push_front(get_node(NodePath(state_name)))
	
	transitioned.emit(previous_state_name, state_name)
	_state_kwargs[state_name] = kwargs


## Pops back the front current state with underlying one in the state stack.
## Optionally, takes a [param kwargs] dictionary to pass data to the state.
func transition_back(kwargs := {}) -> void:
	if len(states) < 2:
		push_error("There is no underlying state in the state stack for the transition")
		return
	
	var previous_state_name = current_state.name
	states.pop_front()
	var current_state_name = current_state.name
	
	transitioned.emit(previous_state_name, current_state_name)
	_state_kwargs[current_state_name] = kwargs


## Resets the state machine.
func reset() -> void:
	if current_state:
		current_state.end()
