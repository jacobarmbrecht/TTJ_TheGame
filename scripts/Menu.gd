extends Control

var health_mask = preload("res://resources/healthmask.tres").duplicate(true)
var boss_health_mask = health_mask.duplicate(true)
var player_special_mask = health_mask.duplicate(true)

func _ready():
	$Control/Healthbar.material.set_shader_param("MASK", health_mask)
	$Control2/BossHealthbar.material.set_shader_param("MASK", boss_health_mask)
	$Control3/Specialbar.material.set_shader_param("MASK", player_special_mask)

func _process(_delta):
	# Player health
	var pos = HealthController.get_player_health()
	var pos2 = pos + 0.01
	var grad = health_mask.get_gradient()
	grad.set_offset(0, pos)
	grad.set_offset(1, pos2)
	# Boss health
	pos = HealthController.get_boss_health()
	pos2 = pos + 0.01
	grad = boss_health_mask.get_gradient()
	grad.set_offset(0, pos)
	grad.set_offset(1, pos2)
	
	pos = HealthController.get_player_special()
	pos2 = pos + 0.01
	grad = player_special_mask.get_gradient()
	grad.set_offset(0, pos)
	grad.set_offset(1, pos2)
