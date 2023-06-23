class_name DisplaySystem
extends System

var clear_mode: SubViewport.ClearMode:
	set(value): _sub_viewport.render_target_clear_mode = value

var update_mode: SubViewport.UpdateMode:
	set(value): _sub_viewport.render_target_update_mode = value

var viewport_scale: Vector2:
	set(value): set('scale', value)

@onready
var _sub_viewport: SubViewport = $SubViewport
