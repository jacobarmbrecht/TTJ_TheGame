extends KinematicBody2D

onready var anim_tree = $AnimationPlayer/AnimationTree
onready var attacks = $Body/Sprite/Attacks

export var speed : int = 100 ## Player speed
export var jumpForce : int = 500
export var gravity : int = 800
var velocity = Vector2.ZERO  ## The player's movement vector.

var is_attacking = false
var attack_rate_done = true

func _physics_process(delta):

	var attack_pressed = false
	var special_pressed = false
	var taunt_pressed = false


	## "disable" inputs when the player is attacking
	if !is_attacking:
		velocity.x = 0
		## Movement is just if because of additive velocities
		if Input.is_action_pressed("right"):
			velocity.x += speed
		if Input.is_action_pressed("left"):
			velocity.x -= speed

		## Jump
		if Input.is_action_pressed("jump") and is_on_floor():
			velocity.y -= jumpForce

		## Attack buttons are and if elif case
		if Input.is_action_pressed("attack"):
			if is_on_floor(): ## Allow movement if attacking from air, but not on the ground
				velocity.x = 0
			attack_pressed = true
		elif Input.is_action_pressed("special"):
			velocity.x = 0
			special_pressed = true
		elif Input.is_action_pressed("taunt"):
			velocity.x = 0
			taunt_pressed = true

		if velocity.x != 0:
			$Body.scale.x = 1 if velocity.x > 0 else -1

		if attack_pressed and attack_rate_done:
			do_attack()
			is_attacking = true
			$AttackTimer.start()
			attack_rate_done = false
			$AttackRate.start()
		elif special_pressed and attack_rate_done:
			is_attacking = true
			$SpecialTimer.start()
			attack_rate_done = false
			$AttackRate.start()
		elif taunt_pressed and attack_rate_done:
			do_point()
			is_attacking = true
			$TauntTimer.start()
			attack_rate_done = false
			$AttackRate.start()

	velocity.y += gravity*delta
	velocity = move_and_slide(velocity, Vector2.UP)

func do_attack():
	anim_tree["parameters/Attack/active"] = 1
	
func do_point():
	anim_tree["parameters/Point/active"] = 1
	
func handle_taunt():
	print("Fuck you")

## Timer destination for ending the attack animations
## XXX: Do we still need this?
func end_attack():
	is_attacking = false

## Just measures overall attack rate
func attack_rate_timeout():
	attack_rate_done = true

func start(pos):
	position = pos
	show()

func attack_damage():
	var baddie = attacks.get_node("Guitar").get_collider()
	if baddie and baddie.has_method("die"):
		baddie.call_deferred("die")
