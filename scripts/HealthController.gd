extends Node

const PLAYER_HEALTH_MAX = 1000
const PLAYER_SPECIAL_MAX = 10
signal death
signal player_dam

const BOSS_HEALTH_MAX = 10
signal boss_death
signal boss_dam


onready var player_health = PLAYER_HEALTH_MAX
onready var player_special = 0
onready var first_hit = true

onready var boss_health = BOSS_HEALTH_MAX

func _ready():
	boss_health = BOSS_HEALTH_MAX
	player_health = PLAYER_HEALTH_MAX
	player_special = 0
	player_special -= 1
	first_hit = true
	print(player_special)
	

func get_player_health():
	return inverse_lerp(0, PLAYER_HEALTH_MAX, player_health)
	
func get_player_special():
	return inverse_lerp(0, PLAYER_SPECIAL_MAX, player_special)

func pickup():
	if first_hit:
		first_hit = false
		player_special += 10
	elif player_special - 1 < 0:
		pass
	else:
		player_special -= 1
		
	print(player_special)
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
		
func restart_game():
	boss_health = BOSS_HEALTH_MAX
	player_health = PLAYER_HEALTH_MAX
	player_special = -1
	first_hit = true

func refresh_pickup():
	print("pickups refreshed")
	player_special += PLAYER_SPECIAL_MAX
	pickup()
	first_hit = true
	print(player_special)
