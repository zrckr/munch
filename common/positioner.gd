class_name Positioner
extends RefCounted

enum Type {
	INSIDE_THE_MAP,
	NEAR_EDGES_OF_MAP,
	OUTSIDE_THE_MAP,
	RANDOMLY_SELECT,
}

##
var _min_position: Vector2

##
var _max_position: Vector2

##
var _edge_offset: float


func set_min_position(value: Vector2) -> Positioner:
	_min_position = value
	return self


func set_max_position(value: Vector2) -> Positioner:
	_max_position = value
	return self


func set_edge_offset(value: float) -> Positioner:
	_edge_offset = value
	return self


func get_clamped(position: Vector2) -> Vector2:
	return Math.clampv(position, 
		_min_position + Math.vec2(_edge_offset),
		_max_position - Math.vec2(_edge_offset))


func get_center_of_box() -> Vector2:
	return (_max_position - _min_position) / 2.0


func get_random_inside_box() -> Vector2:
	var minimum = _min_position + Math.vec2(_edge_offset)
	var maximum = _max_position - Math.vec2(_edge_offset)
	return Random.randv_axes(minimum, maximum)


func get_random_inside_area(position: Vector2, radius: float) -> Vector2:
	var offset = _edge_offset + radius
	var minimum = _min_position + Math.vec2(offset)
	var maximum = _max_position - Math.vec2(offset)
	var clamped = Math.clampv(position, minimum, maximum)
	
	var from = clamped - Math.vec2(radius)
	var to = clamped + Math.vec2(radius)
	return Random.randv_axes(from, to)


func get_random_outside_box() -> Vector2:
	var top_left = _min_position - Math.vec2(_edge_offset)
	var bottom_right = _max_position + Math.vec2(_edge_offset)
	var top_right = Vector2(bottom_right.x, top_left.y)
	var bottom_left = Vector2(top_left.x, bottom_right.y)

	var top = Random.randv_axes(top_left, top_right)
	var bottom = Random.randv_axes(bottom_left, bottom_right)
	var left = Random.randv_axes(top_left, bottom_left)
	var right = Random.randv_axes(top_right, bottom_right)
	
	return Random.randa_choose([top, left, bottom, right])


func get_random_at_edges_of_box(direction: Vector2) -> Vector2:
	if direction.is_zero_approx():
		return Vector2.ZERO
	
	var minimum = _min_position + Math.vec2(_edge_offset)
	var maximum = _max_position - Math.vec2(_edge_offset)
	var random = Random.randv_axes(minimum, maximum)
	
	var positive = (direction.x + direction.y) > 0
	var directed = (minimum if positive else maximum) * direction.abs()
	var masked = random * Math.maskv(direction)
	
	return masked + directed


func get_random_by_type(type: Type) -> Vector2:
	if type == Type.RANDOMLY_SELECT:
		type = (randi() % len(Type) - 1) as Type
	
	match type:
		Type.INSIDE_THE_MAP:
			return get_random_inside_box()
		Type.NEAR_EDGES_OF_MAP:
			var direction = Random.randa_choose(Math.DIRECTIONS)
			return get_random_at_edges_of_box(direction)
		Type.OUTSIDE_THE_MAP:
			return get_random_outside_box()
	
	return Vector2.ZERO


func is_inside_bounds(position: Vector2) -> bool:
	var inside_x = position.x > _min_position.x and position.x < _max_position.x
	var inside_y = position.y > _min_position.y and position.y < _max_position.y
	return inside_x and inside_y


func duplicate() -> Positioner:
	return Positioner.new() \
		.set_min_position(_min_position) \
		.set_max_position(_max_position) \
		.set_edge_offset(_edge_offset)
