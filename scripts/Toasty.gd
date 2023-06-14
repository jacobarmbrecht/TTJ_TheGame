extends Node2D

func _ready():
	$AnimationPlayer.connect("animation_finished", self, "cleanup")
	$AnimationPlayer.play("Toasty")

func cleanup(animation):
	if animation == "Toasty":
		queue_free()
