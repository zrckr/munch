extends EntityState

const INFINITE_HEALTH_POINTS := -1

const MUNCHIES_TOTAL_FALLBACK := 100

var health_points: int:
	get:
		return health_points
	set(value):
		health_points = value
		Events.player_health_updated.emit(value)

var facing_direction := Vector2i.DOWN

var munchies_eaten: int:
	get:
		return munchies_eaten
	set(value):
		munchies_eaten = value
		Events.player_munchies_eaten.emit(value, munchies_total)

var munchies_total := MUNCHIES_TOTAL_FALLBACK


func take_damage(damage_points: int) -> void:
	if health_points != INFINITE_HEALTH_POINTS:
		Events.player_damaged.emit()
		health_points -= damage_points
