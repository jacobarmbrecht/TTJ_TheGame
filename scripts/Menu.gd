extends Control

var health_mask = preload("res://resources/healthmask.tres").duplicate(true)

func _ready():
	$Control/Healthbar.material.set_shader_param("MASK", health_mask)

func _process(_delta):
	var pos = HealthController.get_player_health()
	var pos2 = pos + 0.01
	var grad = health_mask.get_gradient()
	grad.set_offset(0, pos)
	grad.set_offset(1, pos2)
