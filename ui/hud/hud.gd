extends Control

@onready
var player_ability: Label = %PlayerAbility

@onready
var time_left: Label = %TimeLeft

@onready
var munchies_eaten: Label = %MunchiesEaten

@onready
var player_health: Label = %PlayerHealth

var _player_properties: EntityProperties


func _ready() -> void:
	_on_player_munchies_eaten(0, 0)


func _enter_tree() -> void:
	Events.player_health_updated.connect(_on_player_health_updated)
	Events.player_rolled_the_dice.connect(_on_player_rolled_the_dice)
	Events.player_roll_ticked.connect(_on_player_roll_ticked)
	Events.player_roll_worn_off.connect(_on_player_worn_off)
	Events.player_munchies_eaten.connect(_on_player_munchies_eaten)
	
	Events.round_succesed.connect(_on_round_succesed)
	Events.round_failed.connect(_on_round_failed)
	Events.round_ticked.connect(_on_round_ticked)


func _exit_tree() -> void:
	Events.player_health_updated.disconnect(_on_player_health_updated)
	Events.player_rolled_the_dice.disconnect(_on_player_rolled_the_dice)
	Events.player_roll_ticked.disconnect(_on_player_roll_ticked)
	Events.player_roll_worn_off.disconnect(_on_player_worn_off)
	Events.player_munchies_eaten.disconnect(_on_player_munchies_eaten)
	
	Events.round_succesed.disconnect(_on_round_succesed)
	Events.round_failed.disconnect(_on_round_failed)
	Events.round_ticked.disconnect(_on_round_ticked)


func _on_player_health_updated(health: int) -> void:
	player_health.visible = true
	player_health.text = 'HP: %d' % health


func _on_player_rolled_the_dice(properties: EntityProperties) -> void:
	player_ability.text = properties.display_name
	_player_properties = properties
	
	match properties.entity_group:
		Entity.Group.POSITIVE_ROLL:
			munchies_eaten.text = 'FIGHT!'
		Entity.Group.NEGATIVE_ROLL:
			munchies_eaten.text = 'AVOID!'


func _on_player_roll_ticked(time: int) -> void:
	player_ability.text = _player_properties.display_name + ': %d' % time


func _on_player_worn_off(properties: EntityProperties) -> void:
	player_ability.text = properties.display_name


func _on_player_munchies_eaten(munchies: int, total: int) -> void:
	match munchies:
		0:
			munchies_eaten.text = 'EAT MUNCHIES!'
		1:
			munchies_eaten.text = 'ALRIGHT %d/%d' % [munchies, total]
		2:
			munchies_eaten.text = 'AWESOME %d/%d' % [munchies, total]
		3:
			munchies_eaten.text = 'ALMOST %d/%d' % [munchies, total]


func _on_round_succesed() -> void:
	munchies_eaten.visible = false
	player_health.visible = false
	player_ability.visible = false
	time_left.text = 'YOU ARE WINNER!'


func _on_round_failed() -> void:
	munchies_eaten.visible = false
	player_health.visible = false
	player_ability.visible = false
	time_left.text = 'GAME OVER'


func _on_round_ticked(time: int) -> void:
	time_left.text = '%d' % time
