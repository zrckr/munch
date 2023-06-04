extends Node

const Groups := {
	PLAYER = &'player',
	ENEMIES = &'enemies',
	POSITIVE = &'positive',
	NEGATIVE = &'negative',
	MUNCHIES = &'munchies',
}

const Systems := {
	RTD = &'rtd',
	ROUND = &'round',
	SUMMON = &'summon'
}


func is_known_group(node: Node) -> bool:
	var is_present := false
	for group in Groups.values():
		is_present = is_present or node.is_in_group(group)
	return is_present


func get_player() -> Node:
	return get_tree().get_first_node_in_group(Groups.PLAYER)


func get_rtd() -> RtdSystem:
	return get_tree().get_first_node_in_group(Systems.RTD)


func get_round() -> RoundSystem:
	return get_tree().get_first_node_in_group(Systems.ROUND)


func get_summon() -> SummonSystem:
	return get_tree().get_first_node_in_group(Systems.SUMMON)
