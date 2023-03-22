extends Node2D

onready var monday = preload("res://art/images/monday.png")
onready var twothousandone = preload("res://art/images/2001.png")
onready var diuacil = preload("res://art/images/diuacil.png")
onready var pax = preload("res://art/images/pax.png")
onready var brick = preload("res://art/images/castlebrick.png")

onready var sprite = get_node("Sprite")

export var which = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	if which == 1:
		sprite.set_texture(monday)
	elif which == 2:
		sprite.set_texture(twothousandone)
	elif which == 3:
		sprite.set_texture(diuacil)
	elif which == 10000:
		sprite.set_texture(pax)
	else:
		pass




func _on_MobTimer_timeout():
	pass # Replace with function body.
