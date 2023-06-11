extends Node

@onready
var round_system: RoundSystem = $RoundSystem

@onready
var rtd_system: RtdSystem = $RtdSystem


func _ready() -> void:
	round_system.start_next_round()
