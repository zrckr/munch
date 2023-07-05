extends Node

class Action:
	var _action: StringName

	var just_pressed: bool:
		get: return Input.is_action_just_pressed(_action)
	
	var just_released: bool:
		get: return Input.is_action_just_released(_action)
	
	var pressed: bool:
		get: return Input.is_action_pressed(_action)
	
	var strength: float:
		get: return Input.get_action_strength(_action)
	
	func _init(action: StringName) -> void:
		_action = action

#region Devices

const Device := {
	KEYBOARD = &'keyboard',
	GENERIC = &'generic',
	STEAM = &'steam',
	XBOX = &'xbox'
}

const ControlerNames := {
	Device.STEAM: ['Steam'],
	Device.XBOX: ['Xbox', 'X-Box']
}

var device := Device.KEYBOARD

#endregion

#region Actions

var movement: Vector2:
	get: return Input.get_vector(&'left', &'right', &'up', &'down')

var movement_approx: Vector2i:
	get: return Vector2i(movement.round())

var has_movement: bool:
	get: return not movement.is_zero_approx()

var attack := Action.new(&'attack'):
	get: return attack

var use := Action.new(&'use'):
	get: return use

#endregion

func _ready() -> void:
	var joy_connection_changed_signal = Input.joy_connection_changed \
		.connect(_joy_connection_changed_signal)
	
	if joy_connection_changed_signal != OK:
		printerr(_joy_connection_changed_signal)
	
	_detect_device()


func _detect_device() -> void:
	device = _get_controller_type()


func _get_controller_type() -> StringName:
	var controller_name = Input.get_joy_name(0)

	for controller_device in ControlerNames.keys():
		var device_names = ControlerNames[controller_device]
		for device_name in device_names:
			if device_name in controller_name:
				return controller_device
	
	if controller_name:
		return Device.GENERIC
	
	return Device.KEYBOARD


func _joy_connection_changed_signal(_device: int, _connected: int) -> void:
	_detect_device()
