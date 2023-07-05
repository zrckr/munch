extends EntityState

const INFINITE_HEALTH_POINTS := -1

var health_points: int:
	get:
		return health_points
	set(value):
		health_points = value
		Events.player_health_updated.emit(value)

var facing_direction := Vector2.DOWN

var target_body: PhysicsBody2D

var shield_active: bool


func take_damage(damage_points: int) -> void:
	if health_points != INFINITE_HEALTH_POINTS:
		Events.player_damaged.emit()
		health_points -= damage_points
