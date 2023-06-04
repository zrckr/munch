class_name Round
extends Resource

const SPLASH_FALLBACK := 'You forgot to put your "Unique Splash Text™"!'

@export
var groups: Array[RoundGroup]

@export_range(5, 600, 1, 'suffix:seconds')
var duration: int

@export_range(1, 1000, 1, 'suffix:entities')
var max_divils: int

@export_range(1, 1000, 1, 'suffix:entities')
var max_munchies: int

@export
var splash_text := ''
