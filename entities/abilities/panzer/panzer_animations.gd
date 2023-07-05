extends EntityAnimations

@onready
var _turret_sprite: Sprite2D = $TurretSprite

@onready
var _shield_node: Node2D = $ShieldNode


func move() -> void:
	_animation_player.play('default')


func rotate_turret(target_node: Node2D) -> void:
	if not is_instance_valid(target_node):
		_turret_sprite.rotation = 0.0
		return

	var target_angle = entity.global_position \
		.angle_to_point(target_node.global_position)
	
	_turret_sprite.global_rotation = target_angle + Math.HALF_PI


func show_shield() -> void:
	_shield_node.set_deferred('visible', true)


func hide_shield() -> void:
	_shield_node.set_deferred('visible', false)
