extends AnimationComponent


func play_suck_animation(direction: Vector2i) -> void:
	var facing_direction = ''
	if direction.x != 0:
		facing_direction = 'side'
	if direction.y < 0:
		facing_direction = 'up'
	if direction.y > 0:
		facing_direction = 'down'
	
	if facing_direction:
		self.reset()
		_player.play('hoover/suck_' + facing_direction)


func stop_suck_animation() -> void:
	if _player.is_playing():
		_player.play('hoover/RESET')
		_player.advance(0)
		_player.stop()
	self.play_idle()
