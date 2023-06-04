extends Movement

@export
var skin_sprite: SkinSprite

@export_exp_easing('inout')
var skid_factor := 1.0


func _physics_process(delta: float) -> void:
	direction = Input.get_vector('left', 'right', 'up', 'down')
	
	var weight = delta * skid_factor
	if direction.is_zero_approx():
		weight *= skid_factor
	
	character.velocity = character.velocity.lerp(direction * speed, weight)
	character.move_and_slide()
	
	if direction.is_zero_approx():
		skin_sprite.set_idle()
	else:
		var facing_direction = Vector2i(direction.round())
		skin_sprite.set_move(facing_direction)
