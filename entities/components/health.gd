class_name Health
extends Node

const INFINITE_HEALTH := -1

@export
var properties: EntityProperties

@export
var skin_sprite: SkinSprite

##
var value: int:
	get: return _value
	set(new_value):
		if owner.is_in_group(Game.Groups.PLAYER):
			Events.player_health_updated.emit(new_value)
		_value = new_value

##
var _value := 0


func _enter_tree() -> void:
	assert(properties, \
		'No properties present for %s' % get_path())
	
	value = properties.health_value


func _serialize(state: EntityState) -> void:
	state.health = value


func _deserialize(state: EntityState) -> void:
	value = state.health


func take_damage(damage: int) -> void:
	if value == INFINITE_HEALTH:
		return
	
	value -= damage
	if value > 0:
		return
	
	# skin_sprite.set_defeated()
	# await skin_sprite.animation_finished
	
	if owner.is_in_group(Game.Groups.PLAYER):
		Game.get_round().end_current_round()
	
	get_parent().queue_free()


func heal_up(amount: int) -> void:
	if value == INFINITE_HEALTH:
		return
	
	value += amount
	value = min(value, properties.health_overheal)
