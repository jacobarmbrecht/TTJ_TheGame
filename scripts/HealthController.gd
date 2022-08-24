extends Node

const PLAYER_HEALTH_MAX = 1000
signal death

const BOSS_HEALTH_MAX = 20
signal boss_death

onready var player_health = PLAYER_HEALTH_MAX
onready var player_sprite = get_node("Sprite")

onready var boss_health = BOSS_HEALTH_MAX

func get_player_health():
	return inverse_lerp(0, PLAYER_HEALTH_MAX, player_health)

func player_hit():
	if player_health > 0:
		player_health -= 1
	else:
		emit_signal("death")

func get_boss_health():
	return inverse_lerp(0, BOSS_HEALTH_MAX, boss_health)

func boss_hit():
	if boss_health > 0:
		boss_health -= 1
	else:
		emit_signal("boss_death")
