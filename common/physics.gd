class_name Physics

enum Layer {
	NONE = 0,
	NEUTRAL = 1 << 0,
	OBSTACLES = 1 << 1,
	PLAYER = 1 << 2,
	DIVILS = 1 << 3,
	PROJECTILES = 1 << 4,
	ROLLED_THE_DICE = 1 << 5,
	MUNCHIES = 1 << 6,
}
