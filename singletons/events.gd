extends Node

#region Round

signal round_started()

signal round_ticked(time)

signal round_succesed()

signal round_failed()

#endregion

#region Player

signal player_spawned()

signal player_health_updated(health)

signal player_munchies_eaten(munchies, total)

signal player_rolled_the_dice(ability)

signal player_roll_ticked(time)

signal player_wasted_the_roll()

signal player_roll_worn_off()

signal player_damaged()

signal player_died()

#endregion

#region Enemy

signal enemy_spawned(enemy)

signal enemy_health_updated(enemy, health)

signal enemy_state_changed(enemy, state)

signal enemy_damaged(enemy, damage)

signal enemy_died(enemy)

#endregion

#region Munch

signal munch_spawned(munch)

signal munch_eaten(munch)

#endregion

func _ready() -> void:
	if not OS.is_debug_build():
		return
	
	Events.player_spawned.connect(func():
		print('PLAYER: Spawned')
	)
	
	Events.player_health_updated.connect(func(health):
		print('PLAYER: Health = %d' % health)
	)
	
	Events.player_munchies_eaten.connect(func(munchies, total):
		print('PLAYER: Eaten %d/%d munchies' % [munchies, total])
	)
	
	Events.player_rolled_the_dice.connect(func(ability):
		print('RTD: Player rolled the %s roll!' % ability.name)
	)
	
	Events.player_wasted_the_roll.connect(func():
		print('RTD: Player wasted its roll')
	)
	
	Events.player_roll_worn_off.connect(func():
		print('RTD: Player\'s roll has worn off')
	)
	
	Events.player_damaged.connect(func():
		print('PLAYER: Damaged')
	)
	
	Events.player_died.connect(func():
		print('PLAYER: Died')
	)
	
