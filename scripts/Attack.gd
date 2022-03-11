extends Area2D
class_name Attack

func _ready():
	connect("body_entered", self, "do_damage")

func do_damage(baddie):
	if baddie.has_method("die"):
		baddie.call_deferred("die")
