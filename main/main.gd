extends Node

var display_sytem: DisplaySystem:
	get: return get_tree().get_first_node_in_group(System.Group.DISPLAY)

var round_system: RoundSystem:
	get: return get_tree().get_first_node_in_group(System.Group.ROUND)

var rtd_system: RtdSystem:
	get: return get_tree().get_first_node_in_group(System.Group.RTD)


func _ready() -> void:
	round_system.start_next_round()
