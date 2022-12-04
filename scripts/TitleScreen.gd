extends Node2D

onready var main_scene = load("res://scenes//Main.tscn")
onready var title_scene = load("res://scenes//TitleScreen.tscn")
onready var options_scene = load("res://scenes//Options.tscn")


func _ready():
	pass # Replace with function body.



func _on_NewGameButton_button_up():
	get_tree().change_scene_to(main_scene)


func _on_OptionsButton_button_up():
	get_tree().change_scene_to(options_scene)
