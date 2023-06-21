@icon('res://editor/icons/hurtbox.png')
class_name HurtboxComponent
extends Area2D

var _entity: Entity:
	get:
		assert(owner is Entity, 'The [%s] is not an Entity' % owner.name)
		return owner as Entity

var _properties: EntityProperties:
	get:
		assert(_entity.properties, 'No EntityProperties present for [%s]' % owner.name)
		return _entity.properties

@onready
var _collision_shape: CollisionShape2D = $Collision


func _serialize(state: EntityState) -> void:
	if _collision_shape:
		state.hurtbox_enabled = not _collision_shape.disabled


func _deserialize(state: EntityState) -> void:
	if _collision_shape:
		_collision_shape.disabled = not state.hurtbox_enabled


func enable() -> void:
	_collision_shape.set_deferred('disabled', false)


func disable() -> void:
	_collision_shape.set_deferred('disabled', true)


func _on_area_entered(damage_source: Area2D) -> void:
	if not _entity.health_component:
		return
	
	var is_projectile = damage_source is Projectile
	var is_hitbox = damage_source is HitboxComponent
	
	if not (is_projectile or is_hitbox):
		push_error('Make sure that damage source is either' +
			' `Projectile` or `HitboxComponent`')
		return
	
	if is_projectile:
		damage_source.queue_free()
	
	self.disable()
	_emit_damaged_event()
	
	_entity.animation_component.play_damaged()
	_entity.health_component.take_damage(damage_source.damage)
	
	var knockback_strength = _properties.speed * damage_source.damage
	var knockback_direction = damage_source.global_position \
		.direction_to(_entity.global_position) \
		.round()
	
	_entity.movement_component.start_knockback(
		knockback_direction,
		knockback_strength)


func _emit_damaged_event() -> void:
	if _entity.is_in_group(Entity.Group.PLAYER):
		Events.player_damaged.emit()
	elif _entity.is_in_group(Entity.Group.ENEMY):
		Events.enemy_damaged.emit(_entity)
