extends KinematicBody2D

signal hit


export var speed : int = 100 #player speed
export var jumpForce : int = 600
export var gravity : int = 800
var velocity : Vector2 = Vector2()  # The player's movement vector.
var screen_size #size of window

var is_attacking
var attack_rate_done = true

func _ready():
	screen_size = get_viewport_rect().size
	$AnimatedSprite.offset = Vector2(0,0)
	


func _physics_process(delta):
	
	var attack_pressed = false
	var special_pressed = false
	var taunt_pressed = false
	
	
	# "disable" inputs when the player is attacking
	if !is_attacking:
		velocity.x = 0
		#movment is just if because of additive velocities
		if Input.is_action_pressed("right"):
			velocity.x += speed
		if Input.is_action_pressed("left"):
			velocity.x -= speed
			

		
		#gravity
		
		
		#jump
		if Input.is_action_pressed("jump") and is_on_floor():
			velocity.y -= jumpForce
			
		#old move and slide

		#attack buttons are and if elif case
		if Input.is_action_pressed("attack"):
			if is_on_floor(): #allow movement if attacking from air, but not on the ground
				velocity.x = 0
			attack_pressed = true
		elif Input.is_action_pressed("special"):
			velocity.x = 0
			special_pressed = true
		elif Input.is_action_pressed("taunt"):
			velocity.x = 0
			taunt_pressed = true
		
		#choose movement anim
		if velocity.x != 0:
			start_walk()
			$AnimatedSprite.animation = "walk"
			$AnimatedSprite.flip_h = velocity.x < 0
		else: #set the default as idle
			end_walk()
			$AnimatedSprite.animation = "idle"
	
		if attack_pressed and attack_rate_done:
			end_walk()
			$AnimatedSprite.animation = "attack"
			$AnimatedSprite.offset = Vector2(0,-21) #offset to deal with difference in frame size (look into using animation player instead of animated sprite)
			is_attacking = true
			$AttackTimer.start()
			attack_rate_done = false
			$AttackRate.start()
		elif special_pressed and attack_rate_done:
			end_walk()
			$AnimatedSprite.animation = "special"
			#$AnimatedSprite.offset = Vector2(-15,-9)
			is_attacking = true
			$SpecialTimer.start()
			attack_rate_done = false
			$AttackRate.start()
		elif taunt_pressed and attack_rate_done:
			end_walk()
			$AnimatedSprite.animation = "taunt"
			is_attacking = true
			$TauntTimer.start()
			attack_rate_done = false
			$AttackRate.start()
		

		$AnimatedSprite.play()
		
	velocity.y += gravity*delta
	velocity = move_and_slide(velocity, Vector2.UP)
	
func start_walk():
	$WalkCollision.show()
	$IdleCollision.hide()

func end_walk():
	$WalkCollision.hide()
	$IdleCollision.show()

func end_attack():
	$AnimatedSprite.offset = Vector2(0,0)
	$AnimatedSprite.animation = "idle"
	is_attacking = false

func attack_rate_timeout():
	attack_rate_done = true

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false

func _on_Player_body_entered(body):
	hide()
	emit_signal("hit")
	$WalkCollision.set_deferred("disabled", true)
