extends KinematicBody2D

onready var anim_tree = $AnimationPlayer/AnimationTree
onready var attacks = $Body/Sprite/Attacks
onready var state_machine = $AnimationPlayer/AnimationTree.get("parameters/playback")
onready var anim = $AnimationPlayer
onready var audioplayer = $AudioStreamPlayer
onready var gameaudio = $GameAudio

var fxpowerup = preload("res://sounds/soundfx/synthsounds/powerup.wav")
var jump = preload("res://sounds/soundfx/synthsounds/jump.wav")
var specialattack = preload("res://sounds/soundfx/synthsounds/specialattack.wav")

var dam1 = preload("res://sounds/soundfx/benjsounds/p/p1.wav")
var dam2 = preload("res://sounds/soundfx/benjsounds/p/p2.wav")
var dam3 = preload("res://sounds/soundfx/benjsounds/p/p3.wav")
var dam4 = preload("res://sounds/soundfx/benjsounds/p/p4.wav")
var dam5 = preload("res://sounds/soundfx/benjsounds/p/p5.wav")
var dam6 = preload("res://sounds/soundfx/benjsounds/p/p6.wav")
var dam7 = preload("res://sounds/soundfx/benjsounds/p/p7.wav")
var dam8 = preload("res://sounds/soundfx/benjsounds/p/p8.wav")
var ded1 = preload("res://sounds/soundfx/benjsounds/p/pd1.wav")
var ded2 = preload("res://sounds/soundfx/benjsounds/p/pd2.wav")

var damaged = [dam1, dam2, dam3, dam4, dam5, dam6, dam7, dam8]
var ded = [ded1, ded2]

signal special_attack
signal refresh_pickup

export var speed : int = 5 ## Player speed
export var jumpForce : int = 450
export var gravity : int = 800
export var damp : float = 0.9
export var friction : float = 100.0
export var min_speed : float = 1.0
export var max_walk_speed : float = 5.0

var velocity = Vector2.ZERO  ## The player's movement vector.

var is_attacking = false
var special = false
var is_jumping = false
var attack_rate_done = true
var can_special = false
var is_dead = false
var boss_dead = false

var pickups = 0

var rng = RandomNumberGenerator.new()
var rand

func _ready():
	rng.randomize()
	HealthController.connect("death", self, "do_death")
	#HealthController.connect("boss_death", self, "boss_died")
	HealthController.connect("player_dam", self, "do_damage")
	pickups = 0

func _physics_process(delta):
	
	if is_on_floor():
		is_jumping = false

	var attack_pressed = false
	var special_pressed = false
	var taunt_pressed = false
	var direction = 1


	## "disable" inputs when the player is attacking
	if !special and !is_attacking and !is_dead and !boss_dead:

		if abs(velocity.x) < min_speed:
			velocity.x = 0.0

		velocity.x = sign(velocity.x) * lerp(0.0, abs(velocity.x), 1.0 - damp * delta)
		if is_on_floor():
			velocity.x = sign(velocity.x) * max(0.0, abs(velocity.x) - friction * delta)
		## Movement is just if because of additive velocities
		if Input.is_action_pressed("right"):
			#velocity.x = max_walk_speed
			velocity.x += speed
			direction = 1
		if Input.is_action_pressed("left"):
			#velocity.x = -max_walk_speed
			velocity.x -= speed
			direction = -1

		$Body.scale.x = 1 if velocity.x > 0 else -1

		## Jump
		if Input.is_action_pressed("jump") and is_on_floor():
			audioplayer.stream = jump
			audioplayer.play()
			velocity.y -= jumpForce
			do_jump()
			is_jumping = true


		## Attack buttons are and if elif case
		if Input.is_action_pressed("attack"):
			if is_on_floor(): ## Allow movement if attacking from air, but not on the ground
				attack_pressed = true
				#velocity.x = 0
			else:
				attack_pressed = true
		elif Input.is_action_pressed("special"):
			if can_special:
				velocity.x = 0
				special_pressed = true
				gameaudio.stream = specialattack
				gameaudio.play()
		elif Input.is_action_pressed("taunt"):
			velocity.x = 0
			taunt_pressed = true

		if velocity.x != 0 and !is_jumping:
			state_machine.travel("Walk")
			#$Body.scale.x = 1 if velocity.x > 0 else -1
		if velocity.length() == 0:
			state_machine.travel("Idle")



		
		if attack_pressed and attack_rate_done:
			do_attack()
			is_attacking = true
			$AttackTimer.start()
			attack_rate_done = false
			$AttackRate.start()
		elif special_pressed and attack_rate_done:
			do_special()
			is_attacking = true
			special = true
			$SpecialTimer.start()
			$AttackRate.start()
			#$AttackTimer.start()
			can_special = false
			pickups = 0
			emit_signal("special_attack")
		elif taunt_pressed and attack_rate_done:
			do_point()
			is_attacking = true
			$TauntTimer.start()
			attack_rate_done = false
			$AttackRate.start()
	else: 
		if is_dead or special:
			velocity = velocity / 1.2 #fake friction
		if boss_dead:
			velocity = velocity / 1.1 #fake friction
			state_machine.travel("Endgame")

	velocity.y += gravity*delta
	velocity = move_and_slide(velocity, Vector2.UP)

func do_attack():
	state_machine.travel("Attack")
	#anim_tree["parameters/Attack/active"] = 1
func do_special():
	state_machine.travel("Special")

func do_point():
	state_machine.travel("Point")
	#anim_tree["parameters/Point/active"] = 1

func handle_taunt():
	print("Frick you")

func do_jump():
	state_machine.travel("Jump")

func do_death():
	state_machine.travel("Death")
	if(!is_dead):
		rand = rng.randi_range(0,1)
		audioplayer.stream = ded[rand]
		audioplayer.play()
	is_dead = true
	
	
func do_damage():
	anim.play("Damage")
	if(!audioplayer.is_playing()):
		rand = rng.randi_range(0,7)
		audioplayer.stream = damaged[rand]
		audioplayer.play()
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

func boss_died():
	boss_dead = true

func _on_Main_onstage():
	boss_dead = true
	



func _on_Pickup_picked_up():
	gameaudio.stream = fxpowerup
	gameaudio.play()
	print("player picked up")
	pickups += 1
	if pickups > 9:
		can_special = true



func end_special_attack():
	is_attacking = false
	special = false
