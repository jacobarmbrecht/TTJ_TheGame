extends KinematicBody2D

const gibs = preload("res://baddies/Gibs.tscn")

signal dead

#onready var audioplayer = /root/
#var oof = preload("res://sounds/soundfx/mannedead.wav")

export (float) var speed = 100
export (float) var gravity = 300
var rng = RandomNumberGenerator.new()

var movement = Vector2(0, 0)

func _ready():
	HealthController.connect("boss_death", self, "uhoh")
	rng.randomize()
	#audioplayer.stream = oof #OOF


func _physics_process(_delta):
	if is_on_floor() and (not $FloorRay.is_colliding() or $WallRay.is_colliding()):
		scale.x *= -1

	if !is_on_floor():
		movement = Vector2(0 , gravity)
	else:
		movement = Vector2(speed , gravity)

	var move_vec = transform.basis_xform(movement) ## Move relative to direction
	move_and_slide(move_vec, Vector2.UP)

	if len($Hurtbox.get_overlapping_bodies()) > 0:
		HealthController.player_hit()


func die():
	emit_signal("dead")
	#var rand = rng.randf_range(0,2)
	#audioplayer.pitch_scale = rand
	#audioplayer.play()
	var gibs_instance = gibs.instance()
	get_parent().add_child(gibs_instance)
	gibs_instance.position = position
	queue_free() #allow sound to end before destroying object

	
func uhoh(): #randomized death
	
	var rand = rng.randf_range(0,2)
	#audioplayer.voice_set_pitch_scale(0, rand)
	yield(get_tree().create_timer(rand), "timeout")
	die()


