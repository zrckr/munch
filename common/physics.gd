class_name Physics

enum Layer {
	NEUTRAL = 1 << 0,
	PLAYER_ENTITY = 1 << 1,
	PLAYER_DAMAGE = 1 << 2,
	ENEMY_ENTITY = 1 << 3,
	ENEMY_DAMAGE = 1 << 4,
	MUNCH = 1 << 5,
}
