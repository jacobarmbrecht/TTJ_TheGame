extends Node2D

export(PackedScene) var mob_scene
var score
var rng = RandomNumberGenerator.new()

func _ready():
	randomize()
	$MobTimer.start()
	score = 0
	
	
func game_over():
	$MobTimer.stop()
	
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

func dead_mob():
	score+=1
	print(score)
