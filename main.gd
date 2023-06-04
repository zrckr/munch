extends Node

@onready
var round_system: RoundSystem = $RoundSystem

@onready
var rtd_system: RtdSystem = $RtdSystem

@onready
var summon_system: SummonSystem = $SummonSystem

@onready
var dots_map: Node = $Dots


func _ready() -> void:
	summon_system.min_position = dots_map.minimum_global_position
	summon_system.max_position = dots_map.maximum_global_position
	round_system.start_next_round()
