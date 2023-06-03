extends Area2D
class_name Attack

onready var audioplayer = $AudioStreamPlayer
var oof = preload("res://sounds/soundfx/hitHurt.wav")

export var pitchscale = 0.5
signal destroyed

func _ready():
	connect("body_entered", self, "do_damage")
	audioplayer.stream = oof

func do_damage(baddie):
	audioplayer.pitch_scale = pitchscale
	audioplayer.stream = oof
	audioplayer.play()
	if baddie.has_method("die"):
		baddie.call_deferred("die")
		emit_signal("destroyed")
	elif baddie.has_method("take_damage"):
		baddie.call_deferred("take_damage")
	audioplayer.pitch_scale = 1
