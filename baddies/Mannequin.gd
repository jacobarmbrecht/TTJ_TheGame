extends KinematicBody2D

export (float) var SPEED = 0.5

var movement = Vector2(100, 100)

func _physics_process(delta):
	if is_on_floor():
		if not $FloorRay.is_colliding() or $WallRay.is_colliding():
			scale.x *= -1
	var move_vec = transform.basis_xform(movement) ## Move relative to direction
	move_and_slide(move_vec, Vector2.UP)
