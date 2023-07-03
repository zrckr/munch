extends EntityAnimations


func rolling(speed_scale := 1.0) -> void:
	_animation_player.speed_scale = clampf(speed_scale, -2.0, 2.0)
	if _animation_player.current_animation != 'bigboy/rolling':
		_animation_player.play('bigboy/rolling')
