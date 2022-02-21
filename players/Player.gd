extends KinematicBody2D

onready var anim_tree = $AnimationPlayer/AnimationTree
var velocity = Vector2.ZERO

func attack_damage():
	var baddie = $Sprite/Attacks/Guitar.get_collider()
	if baddie and baddie.has_method("die"):
		baddie.call_deferred("die")

func _process(delta):
	if Input.is_action_just_pressed("attack"): do_attack()

func do_attack():
	anim_tree["parameters/Attack/active"] = 1

func _physics_process(delta):
	var move_vec = Vector2.ZERO
	move_vec.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	move_vec.x *= 100.0
	if Input.is_action_just_pressed("jump") and is_on_floor():
		move_vec += Vector2.UP * 150
	move_vec += Vector2.DOWN * 98 * delta
	velocity = move_and_slide(move_vec + velocity, Vector2.UP)
	if velocity.x < 0:
		$Sprite.scale.x = -1
	elif velocity.x > 0:
		$Sprite.scale.x = 1
	velocity.x = 0
