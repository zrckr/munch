class_name Random


static func randp(probability: float) -> bool:
	return probability > randf()


static func randv_unit() -> Vector2:
	return Vector2(randf(), randf())


static func randv_range(from: float, to: float) -> Vector2:
	return Vector2(
		randf_range(from, to),
		randf_range(from, to))


static func randv_axes(from: Vector2, to: Vector2) -> Vector2:
	return Vector2(
		randf_range(from.x, to.x),
		randf_range(from.y, to.y))


static func randa_choose(array: Array[Variant]) -> Variant:
	return array[randi() % len(array)]
