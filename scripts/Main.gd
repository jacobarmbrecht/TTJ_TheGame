extends Node2D

onready var audioplayer = $AudioStreamPlayer
var song = preload("res://sounds/ttjvg_monday.wav")
var endsong = preload("res://sounds/endgame/ttvg_ah.wav")

onready var tileMap = $HiddenDoor
signal onstage

export(PackedScene) var mob_scene
var boss_died = false
var score
var rng = RandomNumberGenerator.new()

func _ready():
	randomize()
	$MobTimer.start()
	score = 0
	HealthController.connect("death", self, "player_dead")
	HealthController.connect("boss_death", self, "boss_died")
	get_node("Player/Body/Sprite/Attacks/Guitar").connect("destroyed", get_node("Humuncules"), "manne_destroyed")

func _process(delta):
	if!audioplayer.is_playing() and !boss_died:
		audioplayer.stream = song
		audioplayer.play()
	
func game_over():
	#$MobTimer.stop()

	#audioplayer.stop()
	emit_signal("onstage")
	audioplayer.stream = endsong
	audioplayer.play()
	
func new_game():
	score = 0
	#$Player.start($StartPosition.position)



func _on_MobTimer_timeout():
	#Create a new instance of the Mob scene
	var mob = mob_scene.instance()
	
	var mob_spawn_location = get_node("MobSpawnLocation")
	#
	mob.position = mob_spawn_location.position
	add_child(mob)
	

func boss_died():
	boss_died = true
	$MobTimer.stop()
	var index = 0
	#still needs implemented
	tileMap.visible = false
	audioplayer.stop()
	#game_over()

func dead_mob():
	score+=1
	print(score)
	

func player_dead():
	pass
