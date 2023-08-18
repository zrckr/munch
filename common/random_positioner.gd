class_name RandomPositioner
extends RefCounted

enum Type {
	INSIDE_THE_MAP,
	NEAR_EDGES_OF_MAP,
	OUTSIDE_THE_MAP,
	RANDOMLY_SELECT,
}

var _map_size := Rect2()

var _edge_offset := 0.0

var _random := RandomNumberGenerator.new()

var _edges: Vector2:
	get: return Vector2.ONE * _edge_offset


func _init() -> void:
	_random.randomize()


func set_map_size(value: Rect2) -> RandomPositioner:
	_map_size = value
	return self


func set_edge_offset(value: float) -> RandomPositioner:
	_edge_offset = value
	return self


func set_seed(value: int) -> RandomPositioner:
	_random.seed = value
	return self


func set_state(value: int) -> RandomPositioner:
	_random.state = value
	return self


func get_position_in_map_center() -> Vector2:
	return _map_size.get_center()


func get_position_by_type(type: Type) -> Vector2:
	if type == Type.RANDOMLY_SELECT:
		type = (_random.randi() % (len(Type) - 1)) as Type
	
	match type:
		Type.INSIDE_THE_MAP:
			return get_position_on_map()
		Type.NEAR_EDGES_OF_MAP:
			var direction = _rand_choose(Math.DIRECTIONS)
			return get_position_at_edges_of_map(direction)
		Type.OUTSIDE_THE_MAP:
			return get_position_outside_map()
	
	return _map_size.get_center()


func get_position_on_map() -> Vector2:
	var minimum = _map_size.position + _edges
	var maximum = _map_size.end - _edges
	return _randv_axes(minimum, maximum)


func get_position_at_edges_of_map(direction: Vector2) -> Vector2:
	if direction.is_zero_approx():
		return Vector2.ZERO
	
	var minimum = _map_size.position + _edges
	var maximum = _map_size.end - _edges
	var random = _randv_axes(minimum, maximum)
	
	var positive = (direction.x + direction.y) > 0
	var directed = (minimum if positive else maximum) * direction.abs()
	var masked = random * Math.maskv(direction)
	
	return masked + directed


func get_position_outside_map() -> Vector2:
	var top_left = _map_size.position - _edges
	var bottom_right = _map_size.end + _edges
	
	var top_right = Vector2(bottom_right.x, top_left.y)
	var bottom_left = Vector2(top_left.x, bottom_right.y)

	var top = _randv_axes(top_left, top_right)
	var bottom = _randv_axes(bottom_left, bottom_right)
	var left = _randv_axes(top_left, bottom_left)
	var right = _randv_axes(top_right, bottom_right)
	
	return _rand_choose([top, left, bottom, right])


func get_position_on_spiral(center: Vector2, radius: float, step: float) -> Vector2:
	var distance = sqrt(randf_range(0.25, 1.0)) * radius
	var theta = Math.PHI * TAU * step
	
	return Vector2(
		center.x + distance * cos(theta),
		center.y + distance * sin(theta))


func clamp_inside_map(position: Vector2) -> Vector2:
	if not _map_size.has_point(position):
		push_warning("The position %s is outside the map %s" % \
			[str(position), str(_map_size)])
		return position
	
	return Math.clampv(position,
		_map_size.position + _edges,
		_map_size.end - _edges)


func _randv_axes(from: Vector2, to: Vector2) -> Vector2:
	return Vector2(
		_random.randf_range(from.x, to.x),
		_random.randf_range(from.y, to.y))


func _rand_choose(array: Array[Variant]) -> Variant:
	var index = _random.randi() % len(array)
	return array[index]
