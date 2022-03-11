extends KinematicBody2D

const gibs = preload("res://baddies/Gibs.tscn")

export (float) var SPEED = 0.5

var movement = Vector2(100, 100)

func _physics_process(_delta):
	if is_on_floor() and (not $FloorRay.is_colliding() or $WallRay.is_colliding()):
		scale.x *= -1
	var move_vec = transform.basis_xform(movement) ## Move relative to direction
	move_and_slide(move_vec, Vector2.UP)

func die():
	var gibs_instance = gibs.instance()
	get_parent().add_child(gibs_instance)
	gibs_instance.position = position
	queue_free()
