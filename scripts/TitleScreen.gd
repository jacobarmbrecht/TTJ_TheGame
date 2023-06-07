extends Node2D

onready var main_scene = load("res://scenes//Main.tscn")
onready var title_scene = load("res://scenes//TitleScreen.tscn")
onready var options_scene = load("res://scenes//Options.tscn")
onready var audioplayer = $AudioStreamPlayer

var  keysound = preload("res://sounds/soundfx/synthsounds/key.wav")


func _ready():
	audioplayer.stream = keysound
	audioplayer.play()



func _on_NewGameButton_button_up():
	get_tree().change_scene_to(main_scene)


func _on_OptionsButton_button_up():
	get_tree().change_scene_to(options_scene)



func _on_NewTextButton_button_up():
	get_tree().change_scene_to(main_scene)


func _on_OptTextButton_button_up():
	get_tree().change_scene_to(options_scene)



