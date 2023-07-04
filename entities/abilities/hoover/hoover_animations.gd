extends EntityAnimations


func idle(direction := Vector2.DOWN) -> void:
	_play_directional_animation('idle', direction)


func idle_ears() -> void:
	_animation_player.play('idle_ears')


func move(direction := Vector2.DOWN, speed_scale := 1.0) -> void:
	_play_directional_animation('move', direction)
	_animation_player.speed_scale = speed_scale


func defeated() -> void:
	_animation_player.play('defeated')


func suck(direction := Vector2.DOWN) -> void:
	_play_directional_animation('hoover/suck', direction)


func reset() -> void:
	_animation_player.play('hoover/RESET')
	_animation_player.advance(0)
	_animation_player.play('RESET')
