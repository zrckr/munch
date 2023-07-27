@icon('res://editor/icons/component.png')
class_name MunchComponent
extends Node

@export_range(1, 100, 1, 'suffix:munchies')
var munchies_total_fallback := 100

var can_transform_to_ability: bool:
	get: return munchies_eaten >= munchies_total

var munchies_eaten: int:
	get:
		return munchies_eaten
	set(value):
		munchies_eaten = value
		Events.player_munchies_eaten.emit(value, munchies_total)

# This variable is injectable
var munchies_total: int


func eat_munch(munch_hitbox: CollisionBox) -> void:
	if munch_hitbox.owner.is_in_group(Entity.Group.MUNCH):
		munch_hitbox.disable()
		munch_hitbox.entity.queue_free()
		munchies_eaten += 1


func _notification(what: int) -> void:
	match what:
		NOTIFICATION_READY:
			if not munchies_total:
				munchies_total = munchies_total_fallback
