extends EntityState

const INFINITE_HEALTH_POINTS := -1

var health_points: int:
	get:
		return health_points
	set(value):
		health_points = value
		Events.player_health_updated.emit(value)

var facing_direction := Vector2i.DOWN

var suction_amount: int:
	get:
		return suction_amount
	set(value):
		suction_amount = value
		suction_callback.call(value)

var suction_callback := Callable()

var suction_tweens := {}


func take_damage(damage_points: int) -> void:
	if health_points != INFINITE_HEALTH_POINTS:
		Events.player_damaged.emit()
		health_points -= damage_points


func get_suction_angle() -> float:
	var direction = Vector2.DOWN
	
	if facing_direction.x > 0:
		direction = Vector2.RIGHT
	if facing_direction.x < 0:
		direction =  Vector2.LEFT
	if facing_direction.y < 0:
		direction =  Vector2.UP
	if facing_direction.y > 0:
		direction =  Vector2.DOWN
	
	return direction.angle() - Math.HALF_PI
