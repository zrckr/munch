extends Movement

const INPUTS := ['left', 'right', 'up', 'down']

@export
var skin_sprite: SkinSprite

##
var _random_sequence := []


func _enter_tree() -> void:
	super._enter_tree()
	_random_sequence = INPUTS.duplicate()
	_random_sequence.shuffle()


func _physics_process(_delta: float) -> void:
	direction = _get_random_direction()
	character.velocity = direction * speed
	character.move_and_slide()
	
	if direction.is_zero_approx():
		skin_sprite.set_idle()
	else:
		var facing_direction = Vector2i(direction.round())
		skin_sprite.set_move(facing_direction)


func _get_random_direction() -> Vector2:
	var left = _random_sequence[0]
	var right = _random_sequence[1]
	var up = _random_sequence[2]
	var down = _random_sequence[3]
	return Input.get_vector(left, right, up, down)
