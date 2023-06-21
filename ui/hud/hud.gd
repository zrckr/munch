extends Control

const MUNCH_ICON := 'res://assets/munch/munch_icon.tres'

const MUNCHIES_STRINGS := {
	0: 'EAT MUNCHIES! ',
	1: 'ALRIGHT',
	2: 'COOL',
	3: 'YES',
}

@export
var splash_scene: PackedScene

var _splash_instance: SplashText

var _rolled_the_dice: bool

@onready
var _splash_placement: Marker2D = $SplashPlacement


func _ready() -> void:
	_on_player_munchies_eaten(0, -1)


func _enter_tree() -> void:
	Events.player_rolled_the_dice.connect(_on_player_rolled_the_dice)
	Events.player_roll_worn_off.connect(_on_player_worn_off)
	Events.player_munchies_eaten.connect(_on_player_munchies_eaten)


func _on_player_rolled_the_dice(properties: EntityProperties) -> void:
	_rolled_the_dice = true
	match properties.entity_group:
		Entity.Group.POSITIVE_ROLL:
			_set_splash_text('EXCELLENT')
		Entity.Group.NEGATIVE_ROLL:
			_set_splash_text('AVOID DIVILS')


func _on_player_worn_off(_properties: EntityProperties) -> void:
	if _rolled_the_dice:
		_rolled_the_dice = false
		_on_player_munchies_eaten(0, -1)


func _on_player_munchies_eaten(munchies: int, total: int) -> void:
	if is_instance_valid(_splash_instance):
		_splash_instance.queue_free()
	
	if munchies != total:
		var text = tr(MUNCHIES_STRINGS.get(munchies))
		_set_splash_text(text, munchies == 0)


func _set_splash_text(text: String, append_icon := false) -> void:
	if is_instance_valid(_splash_instance):
		_splash_instance.queue_free()
	
	_splash_instance = splash_scene.instantiate()
	_splash_instance.set_text(text)
	_splash_instance.set_skew_effect()
	
	if append_icon:
		_splash_instance.append_image(MUNCH_ICON, 16, 16)
	
	_splash_placement.call_deferred('add_child', _splash_instance)
