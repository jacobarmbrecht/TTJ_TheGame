extends Node2D


onready var halo2 = preload("res://art/images/pickups/halo.png")

signal picked_up

func _ready():
	pass



func _on_Area2D_body_entered(body):
	emit_signal("picked_up")
	HealthController.pickup()
	#print("picked up")
	queue_free()
