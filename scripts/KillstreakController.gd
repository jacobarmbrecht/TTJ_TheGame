extends Node

onready var killstreak = 0

signal toast_time

func _ready():
	var tickdown = Timer.new()
	tickdown.connect("timeout", self, "tick")
	tickdown.wait_time = 2.0
	tickdown.autostart = true
	add_child(tickdown)
	
func tick():
	if killstreak >= 4:
		emit_signal("toast_time")
		killstreak = 0
	killstreak = max(killstreak - 1, 0)

func kill():
	killstreak += 1
