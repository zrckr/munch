@icon('res://editor/icons/entity.png')
class_name Entity
extends CharacterBody2D

const Group := {
	# Common
	PLAYER = 'player',
	ENEMY = 'enemy',
	MUNCH = 'munch',
	# RTD
	POSITIVE_ROLL = 'positive_roll',
	NEGATIVE_ROLL = 'negative_roll',
	# Internal
	_ROLL_THE_DICE = '_roll_the_dice',
	_WEAR_OFF_ROLL = '_wear_off_roll',
}

@export
var properties: EntityProperties

##
var state: EntityState:
	get: return _serialize()
	set(value): _deserialize(value)

@onready
var lifetime_component: LifetimeComponent = get_node_or_null('LifetimeComponent'):
	get: return lifetime_component

@onready
var movement_component: MovementComponent = get_node_or_null('MovementComponent'):
	get: return movement_component

@onready
var health_component: HealthComponent = get_node_or_null('HealthComponent'):
	get: return health_component

@onready
var hitbox_component: HitboxComponent = get_node_or_null('HitboxComponent'):
	get: return hitbox_component

@onready
var hurtbox_component: HurtboxComponent = get_node_or_null('HurtboxComponent'):
	get: return hurtbox_component

@onready
var animation_component: AnimationComponent = get_node_or_null('AnimationComponent'):
	get: return animation_component


func _enter_tree() -> void:
	add_to_group(properties.entity_group)
	if not _is_any_group():
		push_error('You forgot to add [%s] to one of these groups: %s' % \
			[get_path(), str(Group.values())])


func roll_the_dice() -> void:
	if not _is_ability():
		add_to_group(Group._ROLL_THE_DICE)


func wear_off_roll() -> void:
	if _is_ability():
		add_to_group(Group._WEAR_OFF_ROLL)


func is_player_ability() -> bool:
	return is_in_group(Group.PLAYER) and _is_ability()


func is_player_default() -> bool:
	return is_in_group(Group.PLAYER) and not _is_ability()


func _serialize() -> EntityState:
	var value := EntityState.new()
	for component in get_children():
		if component.has_method('_serialize'):
			component._serialize(value)
	return value


func _deserialize(value: EntityState) -> void:
	for component in get_children():
		if component.has_method('_deserialize'):
			component._deserialize(value)


func _is_any_group() -> bool:
	var result = false
	for group in Group.values():
		result = result or is_in_group(group)
	return result


func _is_ability() -> bool:
	return is_in_group(Entity.Group.POSITIVE_ROLL) or \
			is_in_group(Entity.Group.NEGATIVE_ROLL)
