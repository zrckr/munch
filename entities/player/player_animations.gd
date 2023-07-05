extends EntityAnimations


func idle(direction := Vector2.DOWN) -> void:
	_play_directional_animation('idle', direction)


func idle_ears() -> void:
	_animation_player.play('idle_ears')


func move(direction := Vector2.DOWN, speed_scale := 1.0) -> void:
	_play_directional_animation('move', direction)
	_animation_player.speed_scale = speed_scale


func damaged() -> void:
	_animation_player.play('damaged')


func defeated() -> void:
	_animation_player.play('defeated')


func begin_transform() -> void:
	pass
