extends EntityState
const INFINITE_HEALTH_POINTS := -1

var facing_direction := Vector2i.DOWN

var target_entity: Entity

var health_points: int:
	get:
		return health_points
	set(value):
		health_points = value
		Events.enemy_health_updated.emit(entity, value)


func _ready() -> void:
	action = &'Chase'


func take_damage(damage_points: int) -> void:
	if health_points != INFINITE_HEALTH_POINTS:
		Events.enemy_damaged.emit(entity)
		health_points -= damage_points
