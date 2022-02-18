extends Node2D

func _ready():
	yield(get_tree(), "physics_frame")
	explode()
	yield(get_tree().create_timer(10.0), "timeout")
	queue_free()

func explode():
	for child in get_children():
		var rot = rand_range(0, PI)
		var force = Vector2.LEFT * 10
		force = force.rotated(rot)
		child.apply_impulse(child.position, force)
