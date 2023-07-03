extends EntityAnimations


func idle(direction := Vector2.DOWN) -> void:
	_animation_player.play('idle')
	# _play_directional_animation('idle', direction)


func move(direction := Vector2.DOWN, speed_scale := 1.0) -> void:
	_play_directional_animation('move', direction)
	_animation_player.speed_scale = speed_scale


func damaged() -> void:
	pass


func defeated() -> void:
	pass
