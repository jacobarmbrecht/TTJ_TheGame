extends Node2D

func explode():
	for child in get_children():
		if child is RigidBody2D:
			var rot = rand_range(0, PI)
			var force = Vector2.LEFT * 10
			force = force.rotated(rot)
			child.apply_impulse(child.position, force)
