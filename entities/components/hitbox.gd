class_name Hitbox
extends Area2D

##
const HITSTUN_TIME := 0.16

##
const INVULN_TIME := 2.0

##
const DAMAGED_BY := {
	Game.Groups.PLAYER: Game.Groups.ENEMIES,
	Game.Groups.ENEMIES: Game.Groups.POSITIVE,
}

@export
var health: Health

@export
var skin_sprite: SkinSprite

##
var hitstun_timer: SceneTreeTimer

##
var invuln_timer: SceneTreeTimer

##
var knockback_direction: Vector2


func _enter_tree() -> void:
	assert(health, 'No health node is present in %s' % get_path())


func _physics_process(_delta: float) -> void:
	for area in get_overlapping_areas():
		var not_stunned = not hitstun_timer
		var not_invuln = not invuln_timer
	
		if not_stunned and not_invuln:
			health.take_damage(1)
			
			hitstun_timer = get_tree().create_timer(HITSTUN_TIME, false, true)
			hitstun_timer.timeout.connect(_on_hitstun_timer_timeout)
		
			if owner is PhysicsBody2D:
				knockback_direction = area.global_position \
					.direction_to(owner.global_position) \
					.round()
			
				if owner.collision_layer & Physics.Layer.PLAYER:
					Events.player_damaged.emit()
	
	if hitstun_timer:
		skin_sprite.modulate_sprite(Color.RED)
		if owner is CharacterBody2D:
			owner.velocity = knockback_direction * 180
			owner.move_and_slide()
	
	if invuln_timer:
		var is_odd_frame = Engine.get_physics_frames() % 3 == 2
		skin_sprite.visible = is_odd_frame
		skin_sprite.modulate_sprite(Color.WHITE)


func _on_hitstun_timer_timeout() -> void:
	hitstun_timer = null
	invuln_timer = get_tree().create_timer(INVULN_TIME, false, true)
	invuln_timer.timeout.connect(_on_invuln_timer_timeout)


func _on_invuln_timer_timeout() -> void:
	invuln_timer = null
	knockback_direction = Vector2.ZERO
	skin_sprite.visible = true
