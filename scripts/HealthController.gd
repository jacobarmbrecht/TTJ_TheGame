extends Node

const PLAYER_HEALTH_MAX = 1000
signal death

onready var player_health = PLAYER_HEALTH_MAX

func get_player_health():
	return inverse_lerp(0, PLAYER_HEALTH_MAX, player_health)

func player_hit():
	if player_health > 0:
		player_health -= 1
	else:
		emit_signal("death")
