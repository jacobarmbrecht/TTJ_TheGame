extends Node2D

onready var audioplayer = $MusicAudio
onready var humaudioplayer = $HumAudio
var s_mon = preload("res://sounds/songs/TTJVG_MONDAY.wav")
var s_buf = preload("res://sounds/songs/TTJVG_BUFFALO.wav")
var endsong = preload("res://sounds/endgame/ttvg_ah.wav")
var deth = preload("res://sounds/soundfx/benjsounds/h/hd1.wav")
var  keysound = preload("res://sounds/soundfx/synthsounds/key.wav")
#var oof = preload("res://sounds/soundfx/explosion(3).wav")
var song = [s_mon, s_buf]
var toasty = preload("res://scenes/Toasty.tscn")

onready var tilemap = $HiddenDoor
onready var camera = $Player/Camera2D
onready var playervar = $Player
onready var endzone = $Endzone
onready var ngbutton = $NewGame
onready var mbutton = $MainMenu
onready var retrybutton = $Retry
onready var boss = $Humuncules
onready var healthcontroller = $"/root/HealthController"
onready var main_scene = load("res://scenes//Main.tscn")
onready var title_scene = load("res://scenes//TitleScreen.tscn")
signal onstage
signal restart

export(PackedScene) var mob_scene
var boss_died = false
var player_died = false
var boss_appeared = false
var score
var rng = RandomNumberGenerator.new()

func _ready():
	audioplayer.stream = keysound
	audioplayer.play()
	rng.randomize()
	$MobTimer.start()
	score = 0
	HealthController.connect("death", self, "player_dead")
	HealthController.connect("boss_death", self, "boss_died")
	KillstreakController.connect("toast_time", self, "on_toast_time")
	#endzone.connect("body_shape_entered", self, "game_over")
	get_node("Player/Body/Sprite/Attacks/Guitar").connect("destroyed", get_node("Humuncules"), "manne_destroyed")
	
	camera.limit_right = 1300
	ngbutton.hide()
	mbutton.hide()
	retrybutton.hide()

func _process(delta):
	if healthcontroller.boss_appeared and !boss_appeared:
		$CanvasLayer/Menu.I_AM_THE_GODFLY()
		boss_appeared = true
	elif !boss_appeared:
		$CanvasLayer/Menu.restart()
	if!audioplayer.is_playing() and !boss_died:
		var rand = rng.randi_range(0,song.size()-1)
		audioplayer.stream = song[rand]
		audioplayer.play()
	
func game_over():
	print("onstage")
	emit_signal("onstage")
	audioplayer.stream = endsong
	audioplayer.play()
	$ButtonTimer.start()
	
func new_game():
	$CanvasLayer/Menu.restart()
	player_died = false
	boss_died = false
	



func _on_MobTimer_timeout():
	#Create a new instance of the Mob scene
	var mob = mob_scene.instance()
	
	var mob_spawn_location = get_node("MobSpawnLocation")
	#
	mob.position = mob_spawn_location.position
	add_child(mob)
	mob.add_to_group("baddies")
	

func boss_died():
	boss_died = true
	$CanvasLayer/Menu.I_AM_NO_LONGER_THE_GODFLY()
	$MobTimer.stop()
	var index = 0
	#still needs implemented
	tilemap.queue_free()
	camera.limit_right = 10000000
	audioplayer.stop()
	humaudioplayer.stream = deth
	humaudioplayer.play()
	#game_over()

func dead_mob():
	score+=1
	#print(score)
	

func player_dead():
	if !player_died:
		player_died = true
		print("dead!")
		retrybutton.transform = playervar.transform
		$ButtonTimer2.start()

func on_toast_time():
	$CanvasLayer.add_child(toasty.instance())


func _on_Area2D_body_entered(body):
	game_over()


func _on_ButtonTimer_timeout():
		ngbutton.show()
		mbutton.show()
		retrybutton.show()


func _on_MenuTextButton_button_up():
	healthcontroller.restart_game()
	$CanvasLayer/Menu.restart()
	player_died = false
	boss_died = false
	get_tree().change_scene_to(title_scene)



func _on_RetryTextButton_button_up():
	healthcontroller.restart_game()
	$CanvasLayer/Menu.restart()
	player_died = false
	boss_died = false
	get_tree().change_scene_to(main_scene)


func _on_NewTextButton_button_up():
	healthcontroller.restart_game()
	$CanvasLayer/Menu.restart()
	player_died = false
	boss_died = false
	get_tree().change_scene_to(main_scene)


func _on_Player_special_attack():
	var badguys = get_tree().get_nodes_in_group("baddies")
	var num_badguys = badguys.size()
	if num_badguys > 0:
		for N in num_badguys:
			dead_mob()
			if !boss_died:
				boss.manne_destroyed()
		get_tree().call_group("baddies", "uhoh")
