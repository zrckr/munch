extends Movement

@export
var skin_sprite: SkinSprite


func _physics_process(_delta: float) -> void:
	direction = Input.get_vector('left', 'right', 'up', 'down')
	character.velocity = direction * speed
	character.move_and_slide()
	
	if direction.is_zero_approx():
		skin_sprite.set_idle()
	else:
		var facing_direction = Vector2i(direction.round())
		skin_sprite.set_move(facing_direction)
