extends State

@export_group('Player Dependencies')
@export var player: Entity
@export var player_animations: EntityAnimations


func begin(_kwargs := {}) -> void:
	Events.player_died.emit()
	player_animations.play('defeated')


func _on_player_animations_finished(anim_name: String) -> void:
	if 'defeated' in anim_name:
		player.queue_free()
