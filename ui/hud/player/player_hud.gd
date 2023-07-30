extends Control

const HeartTexture := {
	EMPTY = preload('res://ui/icons/misc/empty_heart.tres'),
	HALF = preload('res://ui/icons/misc/half_heart.tres'),
	FULL = preload('res://ui/icons/misc/full_heart.tres'),
}

var _default_display_name := Strings.UI_PLAYER_RTD_DEFAULT

var _current_health_index := -1

var _is_both_hearts_affected := false

@onready
var _display_label: Label = %DisplayLabel

@onready
var _health_icons: Array[Node] = %HealthIcons.get_children()

@onready
var _lifetime_container: Control = %LifetimerContainer

@onready
var _lifetime_label: Label = %LifetimeLabel


func _ready() -> void:
	_lifetime_container.visible = false
	Events.player_health_updated.connect(_on_player_health_updated)
	Events.player_damaged.connect(_on_player_damaged)
	Events.player_rolled_the_dice.connect(_on_player_rolled_the_dice)
	Events.player_roll_ticked.connect(_on_player_roll_ticked)
	Events.player_wasted_the_roll.connect(_on_player_wasted_the_roll)
	Events.player_roll_worn_off.connect(_on_player_roll_worn_off)


@warning_ignore('integer_division')
func _on_player_health_updated(current_health: int) -> void:
	_reset_health_icons()
	
	var health_halves = len(_health_icons) * 2
	var health_value = clampi(current_health, 0, health_halves)
	
	for half_index in range(health_halves):
		var heart_index = half_index / 2
		var icon := _health_icons[heart_index] as TextureRect
		
		if half_index > health_value:
			icon.texture = HeartTexture.EMPTY
			continue
		
		icon.texture = HeartTexture.FULL
		_current_health_index = heart_index
		_is_both_hearts_affected = true
		
		if half_index == health_value and half_index % 2 != 0:
			_is_both_hearts_affected = false
			icon.texture = HeartTexture.HALF
			break


func _on_player_damaged() -> void:
	var icon := _health_icons[_current_health_index] as Control
	_shake_control(icon, 2.0, 0.25)
	
	if _is_both_hearts_affected:
		icon = _health_icons[_current_health_index - 1] as Control
		_shake_control(icon, 2.0, 0.25)


func _on_player_rolled_the_dice(properties: EntityProperties) -> void:
	_display_label.text = tr(properties.display_name)
	_lifetime_container.visible = true


func _on_player_roll_ticked(time_left: int) -> void:
	_lifetime_label.text = '%02d' % time_left


func _on_player_wasted_the_roll() -> void:
	_display_label.text = tr(Strings.UI_PLAYER_RTD_WASTED)
	await get_tree().create_timer(1.0, false, false).timeout
	_display_label.text = tr(_default_display_name)


func _on_player_roll_worn_off(properties: EntityProperties) -> void:
	_default_display_name = properties.display_name
	_display_label.text = tr(_default_display_name)
	_lifetime_container.visible = false


func _reset_health_icons() -> void:
	_current_health_index = -1
	for health_icon in _health_icons:
		if health_icon is TextureRect:
			health_icon.texture = HeartTexture.EMPTY


func _shake_control(control: Control, intensity: float, duration: float) -> void:
	var elapsed := 0.0
	var origin := control.position
	
	while elapsed < duration:
		await get_tree().process_frame
		elapsed += get_process_delta_time()
		control.position = origin + Random.randv_unit() * intensity
	
	elapsed = duration
	control.position = origin
