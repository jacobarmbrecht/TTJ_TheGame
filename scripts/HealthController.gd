extends Node

const PLAYER_HEALTH_MAX = 1000
signal death
signal player_dam

const BOSS_HEALTH_MAX = 10
signal boss_death
signal boss_dam


onready var player_health = PLAYER_HEALTH_MAX

onready var boss_health = BOSS_HEALTH_MAX

func _ready():
	boss_health = BOSS_HEALTH_MAX
	player_health = PLAYER_HEALTH_MAX

func get_player_health():
	return inverse_lerp(0, PLAYER_HEALTH_MAX, player_health)

func player_hit():
	if player_health > 0:
		player_health -= 1
		emit_signal("player_dam")
	else:
		emit_signal("death")

func get_boss_health():
	return inverse_lerp(0, BOSS_HEALTH_MAX, boss_health)

func boss_hit():
	if boss_health > 0:
		boss_health -= 1
		emit_signal("boss_dam")
	else:
		emit_signal("boss_death")
		boss_health = BOSS_HEALTH_MAX
		
