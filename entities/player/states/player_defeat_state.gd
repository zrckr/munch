extends State

@export_group('Player Dependencies')
@export var player: Entity
@export var player_animations: EntityAnimations


func _ready() -> void:
	player_animations.finished.connect(on_player_animations_finished)


func begin(_kwargs := {}) -> void:
	Events.player_died.emit()
	player_animations.play('defeated')


func on_player_animations_finished(anim_name: String) -> void:
	if 'defeated' in anim_name:
		player.queue_free()
