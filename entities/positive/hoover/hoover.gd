extends Node2D

@export_range(0, 3.0, 0.1)
var suction_time := 1.0

@export
var movement: Movement

@export
var skin_sprite: SkinSprite

@onready
var animation_player: AnimationPlayer = $AnimationPlayer

@onready
var pivot: Node2D = $Pivot

@onready
var suction_area: Area2D = $Pivot/SuctionArea

##
var suction_tween: Tween


func _ready() -> void:
	suction_area.body_entered.connect(_on_body_entered)


func _enter_tree() -> void:
	assert(skin_sprite, 'No SkinSprite is present for %s' % get_path())


func _physics_process(_delta: float) -> void:
	var direction = Vector2i(movement.direction)
	if direction.length_squared() == 0:
		direction = Vector2i.DOWN
	
	var just_pressed = Input.is_action_just_pressed('attack')
	var pressed = Input.is_action_pressed('attack')
	
	if just_pressed or pressed:
		movement.set_physics_process(false)
		_play_suck_animation(direction)
		return
	
	if Input.is_action_just_released('attack'):
		movement.set_physics_process(true)
		_reset_animation()
		return


func _play_suck_animation(direction: Vector2i) -> void:
	var facing_direction = ''
	if direction.x != 0:
		facing_direction = 'side'
	if direction.y < 0:
		facing_direction = 'up'
	if direction.y > 0:
		facing_direction = 'down'
	
	if facing_direction:
		_flip_particles(direction.x != 0 and direction.x > 0)
		skin_sprite.reset_animation()
		animation_player.play('suck_' + facing_direction)


func _reset_animation() -> void:
	_flip_particles(false)
	_stop_animation(animation_player)
	skin_sprite.set_idle()


func _on_body_entered(body: CollisionObject2D) -> void:
	body.process_mode = Node.PROCESS_MODE_DISABLED
	body.disable_mode = CollisionObject2D.DISABLE_MODE_REMOVE
	
	suction_tween = create_tween() \
		.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS) \
		.set_pause_mode(Tween.TWEEN_PAUSE_BOUND) \
		.set_trans(Tween.TRANS_CUBIC) \
		.set_ease(Tween.EASE_IN) \
		.set_parallel()
	
	suction_tween.tween_property(body, 'position', global_position, suction_time)
	suction_tween.tween_property(body, 'scale', Vector2.ZERO, suction_time)
	
	await suction_tween.finished
	
	if body != null:
		body.queue_free()


func _flip_particles(value: bool) -> void:
	skin_sprite.flip_sprite(value)
	pivot.scale.y = -1 if value else 1


func _stop_animation(anim_player: AnimationPlayer) -> void:
	if anim_player.is_playing():
		anim_player.play('RESET')
		anim_player.advance(0)
		anim_player.stop()
