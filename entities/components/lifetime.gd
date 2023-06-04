class_name Lifetime
extends Timer

const INFINITE_LIFETIME := -1

@export
var properties: EntityProperties

@export
var skin_sprite: SkinSprite

@export
var movement: Movement

##
var character: Node2D:
	get: return get_parent() as Node2D


func _enter_tree() -> void:
	assert(properties, \
		'No properties present for %s' % character.get_path())
	
	if character.get_groups().is_empty():
		push_warning('This node is not in any group: %s',
			character.get_path())
	
	Events.round_started.connect(_on_round_started)
	Events.round_failed.connect(_on_round_failed)
	
	if properties.lifetime > INFINITE_LIFETIME:
		start(properties.lifetime)


func _physics_process(_delta: float) -> void:
	if not is_stopped() and owner.is_in_group(Game.Groups.PLAYER):
		Events.player_roll_ticked.emit(int(time_left))


func _serialize(state: EntityState) -> void:
	if not is_stopped():
		state.lifetime = wait_time


func _deserialize(state: EntityState) -> void:
	start(state.lifetime)


func _on_round_started() -> void:
	owner.queue_free()


func _on_round_failed() -> void:
	owner.queue_free()


func _on_timeout() -> void:
	var rtd := Game.get_rtd()
	if not rtd:
		return
	
	if not rtd.can_roll_the_dice(owner):
		await get_tree().process_frame
		rtd.back_to_default(owner)
	
	owner.queue_free()


func _on_hitbox_body_entered(body: PhysicsBody2D) -> void:
	var rtd := Game.get_rtd()
	if not rtd:
		return
	
	if body.collision_layer & Physics.Layer.MUNCHIES:
		body.queue_free()
		rtd.lower_activation_threshold()
	
	if rtd.can_roll_the_dice(owner):
		await get_tree().process_frame
		rtd.roll_the_dice(owner)
		owner.queue_free()
