extends KinematicBody2D

export (NodePath) var playerNodePath
export var pos_offset = Vector2(50,25)
export var speed = 2
export var threshold = 5


onready var anim_tree = $AnimationPlayer/AnimationTree
onready var anim = $AnimationPlayer
onready var attacks = $Body/Sprite/Attacks
onready var state_machine = $AnimationPlayer/AnimationTree.get("parameters/playback")
onready var sprite = $Body/Sprite
onready var spookytimer = $ITSSPOOKYTIME
onready var attacktimer = $AttackEnd
onready var delaytimer = $AttackDelay
onready var beginattack = $AttackTimer

#audio player variables
onready var audioplayer = $AudioStreamPlayer 

#humuncules
var an1 = preload("res://sounds/soundfx/benjsounds/h/ha1.wav")
var an2 = preload("res://sounds/soundfx/benjsounds/h/ha2.wav")
var an3 = preload("res://sounds/soundfx/benjsounds/h/ha3.wav")
var dam1 = preload("res://sounds/soundfx/benjsounds/h/hd1.wav")
var dam2 = preload("res://sounds/soundfx/benjsounds/h/hd2.wav")
var dam3 = preload("res://sounds/soundfx/benjsounds/h/hd3.wav")
var dam4 = preload("res://sounds/soundfx/benjsounds/h/hd4.wav")
var dam5 = preload("res://sounds/soundfx/benjsounds/h/hd5.wav")
var dam6 = preload("res://sounds/soundfx/benjsounds/h/hd6.wav")
var deth1 = preload("res://sounds/soundfx/benjsounds/h/hdd1.wav")
var deth2 = preload("res://sounds/soundfx/benjsounds/h/hdd2.wav")
var humsounds = [an1, an2, dam4, dam5, dam6]

#mannequin sounds
var mdam1 = preload("res://sounds/soundfx/benjsounds/m/md1.wav")
var mdam2 = preload("res://sounds/soundfx/benjsounds/m/md2.wav")
var mdam3 = preload("res://sounds/soundfx/benjsounds/m/md3.wav")
var mdam4 = preload("res://sounds/soundfx/benjsounds/m/md4.wav")
var mdam5 = preload("res://sounds/soundfx/benjsounds/m/md5.wav")
var mdam6 = preload("res://sounds/soundfx/benjsounds/m/md6.wav")
var mdam7 = preload("res://sounds/soundfx/benjsounds/m/md7.wav")
var mdam8 = preload("res://sounds/soundfx/benjsounds/m/md8.wav")
var mdam9 = preload("res://sounds/soundfx/benjsounds/m/md9.wav")
var mdam10 = preload("res://sounds/soundfx/benjsounds/m/md10.wav")
var mansounds = [mdam1, mdam2, mdam3, mdam4, mdam5, mdam6, mdam7, mdam8, mdam9, mdam10, dam1, dam2, dam3]

var oof = preload("res://sounds/soundfx/explosion(1).wav")

var is_dead = false
var is_attacking = false
var is_moving = false
var is_visible = false
var appeared = false
var is_spooky = false
var childrendestroyed = 0;

var velocity = Vector2(0,0)
var pos

var rng = RandomNumberGenerator.new()


const gibs = preload("res://baddies/BossGibs.tscn")

func _ready():
	Fade_Out()
	rng.randomize()
	HealthController.connect("boss_dam", self, "do_damage")
	HealthController.connect("boss_death", self, "do_death")
	#audioplayer.stream = oof #OOF

func take_damage():
	HealthController.boss_hit()

func _physics_process(delta):

	var modulate_var = sprite.modulate
	#print(modulate_var)
	var move_var

	#get player position for the CHASE
	var player_pos = get_node("/root/Main/Player").get_global_transform()
	pos = player_pos.get_origin() as Vector2




	#velocity = move_and_slide(velocity, Vector2.UP)
	var t
	var r
	t = delta*speed
	if(is_visible):
		Fade_In()
		if(is_dead):
			pass
			#do_death()
		elif(is_attacking):

			if(!is_moving):
				t = 0
				#r = get_attack_r(t)
				is_moving = true

			t = delta*speed
			r = get_attack_r(t)
			move_var = r
		else:

			r = get_move_r(t)
			move_var = r

		if len($Hurtbox.get_overlapping_bodies()) > 0:
			HealthController.player_hit()
	else:
		if(!is_spooky):
			Fade_Out()
		else:
			Fade_In()

		r = get_move_r(t)
		move_var = r

	self.position = move_var

func do_attack():
	attacktimer.start()
	is_attacking = true

func AttackTime():
	delaytimer.start()
	state_machine.travel("Attack")

func AttackTimeFR():
	do_attack()


func SpookyTime():
	is_spooky = true
	spookytimer.start()


func get_attack_r(t: float):
	var curr_pos = self.position as Vector2
	#var player_pos = get_node("/root/Main/Player").get_global_transform()
	#pos = player_pos.get_origin() as Vector2

	#decide which direction we are going
	var multiplier = 1
	if(rng.randi_range(0,1) == 0):
		multiplier = -1

	var dest_pos = pos + Vector2(multiplier*rng.randf_range(500,1000),rng.randf_range(500,1000))

	var q0 = curr_pos.linear_interpolate(pos, t)
	var q1 = pos.linear_interpolate(dest_pos, t)
	var r = q0.linear_interpolate(q1,t)

	return r

func get_move_r(t: float):
	var curr_pos = self.position as Vector2
	var player_pos = get_node("/root/Main/Player").get_global_transform()
	pos = player_pos.get_origin() as Vector2


	var dest_pos = pos + pos_offset

	var r = curr_pos.linear_interpolate(dest_pos,t)

	return r

func Fade_In():
	if(!sprite.modulate.is_equal_approx(Color(1,1,1,1))):
		sprite.modulate += Color(0,0,0,0.01)

func Fade_Out():
	if(!sprite.modulate.is_equal_approx(Color(1,1,1,0))):
		sprite.modulate -= Color(0,0,0,0.01)


func SpookyTimeOver():
	is_spooky = false



func EndAttack():
	is_attacking = false
	pos_offset.x = pos_offset.x * -1 #have the enemy choose the other side after an attack
	pos_offset.x = pos_offset.x * rng.randf_range(0.9, 1.2) #add a little randomness to enemy spacing
	pos_offset.y = pos_offset.y * rng.randf_range(0.7, 1.2)
	state_machine.travel("idle")
	beginattack.start()

func manne_destroyed():
	
	var rand = rng.randf_range(0.5,1.5)
	audioplayer.pitch_scale = rand
	rand = rng.randi_range(0,12)
	audioplayer.stream = mansounds[rand]
	audioplayer.play()
	childrendestroyed += 1;
	print(childrendestroyed)
	if(childrendestroyed > threshold):
		is_visible = true
		if(!appeared):
			rand = rng.randi_range(0,2)
			audioplayer.stream = humsounds[rand]
			audioplayer.pitch_scale = 1
			audioplayer.play()
			beginattack.start()
			appeared = true

func do_damage():
	var rand = rng.randf_range(0.8,1.2)
	audioplayer.pitch_scale = rand
	rand = rng.randi_range(2,4)
	audioplayer.stream = humsounds[rand]
	audioplayer.play()
	anim.play("Damage")
	
func do_death():
	var gibs_instance = gibs.instance()
	get_parent().add_child(gibs_instance)
	gibs_instance.position = position
	queue_free()

