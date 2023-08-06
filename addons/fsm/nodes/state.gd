## Abstract class. Extend it to create own states.
## A [State] can be attached to a [StateMachine] by adding it as a child node to the [StateMachine] node.
@icon("../icons/state.svg")
class_name State
extends Node

## If [code]true[/code], this state will not be processed by the state machine.
@export
var disabled := false

## Reference to the state machine. Use inside state classes to
## transition between states.
var state_machine: StateMachine


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
