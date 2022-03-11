extends Node2D

func _ready():
	yield(get_tree().create_timer(0.1), "timeout")
	explode()
	yield(get_tree().create_timer(10.0), "timeout")
	queue_free()

func explode():
	$CPUParticles2D.emitting = true
	for child in get_children():
		var rot = rand_range(0, PI)
		var force = Vector2.LEFT * 10
		force = force.rotated(rot)
		if child is RigidBody2D:
			child.apply_impulse(child.position, force)
