extends Control

@onready
var _round_label: Label = %RoundLabel

@onready
var _timer_label: Label = %TimerLabel

@onready
var _divil_label: Label = %DivilLabel


func _ready() -> void:
	Events.round_started.connect(_on_round_started)
	Events.round_ticked.connect(_on_round_ticked)


func _process(_delta: float) -> void:
	var enemies = get_tree().get_nodes_in_group(Entity.Group.ENEMY)
	_divil_label.text = '%02d' % len(enemies)


func _on_round_started(round_number: int) -> void:
	_round_label.text = '%3d' % round_number


func _on_round_ticked(time_left: int) -> void:
	_timer_label.text = '%03d' % time_left
