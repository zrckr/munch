extends Movement

@export
var skin_sprite: SkinSprite

@export
var rotation_factor := 1.0

@export
var bullet_projectile: PackedScene

@export
var muzzle_marker: Marker2D


func _physics_process(delta: float) -> void:
	var rotation_direction = Input.get_axis('left', 'right')
	var velocity = transform.y * Input.get_axis('up', 'down') * speed
	
	character.rotation += rotation_direction * rotation_factor * delta
	character.velocity = velocity
	character.move_and_slide()

	if not velocity.is_zero_approx():
		skin_sprite.set_move(Vector2.UP)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed('attack'):
		await get_tree().physics_frame
		_spawn_projectile_instance()


func _spawn_projectile_instance() -> void:
	var projectile = bullet_projectile.instantiate() as Projectile
	projectile.transform = muzzle_marker.global_transform
	
	if character.owner:
		character.owner.add_child(projectile)
	else:
		get_tree().root.add_child(projectile)
