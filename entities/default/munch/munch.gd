extends CharacterBody2D

enum State {
	SCATTER,
	FRIGHTENED,
}

const MIN_ANGLE := -5

const MAX_ANGLE := 5

const SAME_DIRECTION_DISTANCE_FACTOR := 0.8

@export_range(0, 400, 5, 'suffix:px/s')
var default_speed: float

@export
var rotation_factor := 1.0

@onready
var sprite: Sprite2D = $Animation/Sprite

@onready
var animation_player: AnimationPlayer = $Animation/AnimationPlayer

@onready
var detect_area_radius: float = $DetectArea/Collision.shape.radius

@onready
var lost_area_radius: float = $LostArea/Collision.shape.radius

@onready
var timer: Timer = $Timer

##
var positioner: Positioner

##
var target_position: Vector2

##
var default_position: Vector2

##
var chasing_entity: PhysicsBody2D

##
var speed: float

##
var state := State.SCATTER


func _enter_tree() -> void:
	assert(not is_zero_approx(default_speed), \
		'The default speed is zero for %s' % get_path())
	
	if not positioner:
		positioner = Positioner.new() \
			.set_min_position(Vector2.ZERO) \
			.set_max_position(get_viewport_rect().size)
	
	speed = default_speed
	default_position = global_position
	target_position = positioner.get_random_inside_box()
	
	Events.player_rolled_the_dice.connect(_on_player_rolled_the_dice)
	Events.player_roll_worn_off.connect(_on_player_roll_worn_off)


func _exit_tree() -> void:
	Events.player_rolled_the_dice.disconnect(_on_player_rolled_the_dice)
	Events.player_roll_worn_off.disconnect(_on_player_roll_worn_off)


func _physics_process(_delta: float) -> void:
	match state:
		State.SCATTER:
			_find_position_for_scatter()
		State.FRIGHTENED:
			_find_position_during_chase()
	
	_normalize_target_position()
	_look_at_target_position()
	_move_and_play_animation()
	queue_redraw()


func _find_position_for_scatter() -> void:
	var total_munches = len(get_tree().get_nodes_in_group(Game.Groups.MUNCHIES))
	speed = default_speed / total_munches
	
	var distance = global_position.distance_to(target_position)
	if distance <= 1.0 and timer.is_stopped():
		timer.start()


func _find_position_during_chase() -> void:
	var distance = global_position.distance_to(chasing_entity.global_position)
	if distance <= detect_area_radius * SAME_DIRECTION_DISTANCE_FACTOR:
		return
	
	var degrees = randi_range(MIN_ANGLE, MAX_ANGLE)
	var angle = PI + deg_to_rad(degrees)
	
	var direction = global_position.direction_to(chasing_entity.global_position)
	var opposite = direction.rotated(angle)
	
	target_position = global_position + opposite * lost_area_radius
	speed = default_speed


func _normalize_target_position() -> void:
	var outside_x = target_position.x <= positioner.min_position.x or \
		target_position.x >= positioner.min_position.x
	
	var outside_y = target_position.y <= positioner.min_position.y or \
		target_position.y >= positioner.min_position.y
	
	if outside_x or outside_y:
		target_position = positioner \
			.set_edge_offset(Math.QUADRUPLE) \
			.get_clamped(target_position)


func _look_at_target_position() -> void:
	if timer.is_stopped():
		var angle = (to_local(target_position) * scale).angle()
		rotation = lerp(rotation, rotation + angle, rotation_factor)


func _move_and_play_animation() -> void:
	velocity = global_position.direction_to(target_position) * speed
	move_and_slide()
	
	var custom_speed = speed / default_speed
	animation_player.play('default', -1, _linear_equation(custom_speed))


func _on_body_detected(body: PhysicsBody2D) -> void:
	if not chasing_entity and body.collision_layer & Physics.Layer.PLAYER:
		chasing_entity = body
		state = State.FRIGHTENED


func _on_body_lost(body: PhysicsBody2D) -> void:
	if chasing_entity == body:
		chasing_entity = null
		state = State.SCATTER


func _on_timer_timeout() -> void:
	var offset = Random.randv_range(-Math.SEXTUPLE, Math.SEXTUPLE)
	target_position = positioner \
		.set_edge_offset(Math.QUADRUPLE) \
		.get_clamped(global_position + offset)


func _on_player_rolled_the_dice(_ability: Node) -> void:
	sprite.modulate.a = 0.25


func _on_player_roll_worn_off() -> void:
	sprite.modulate.a = 1.0


func _linear_equation(x: float) -> float:
	return 1.75 - 0.25 * x
