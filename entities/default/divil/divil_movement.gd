extends Movement

@export
var skin_sprite: SkinSprite

@onready
var collision: CollisionShape2D = $DetectionArea/Collision

##
var _target_to_chase: CharacterBody2D


func _physics_process(_delta: float) -> void:
	if not _target_to_chase:
		skin_sprite.set_idle()
		_target_to_chase = Game.get_player()
		return
	
	direction = self.global_position \
		.direction_to(_target_to_chase.global_position)
	
	character.velocity = direction * speed
	character.move_and_slide()
	
	if not direction.is_zero_approx():
		var facing_direction = Vector2i(direction.round())
		skin_sprite.set_move(facing_direction)


func _on_detection_area_body_entered(body: CharacterBody2D) -> void:
	pass
