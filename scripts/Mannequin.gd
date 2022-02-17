extends Area2D

export var speed : int = 100
export var moveDist : int = 100
#export var gravity : int = 800

onready var startX : float = position.x
onready var targetX : float = position.x + moveDist

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _physics_process(delta):
	
	#move to target
	position.x = move_to(position.x, targetX, speed*delta)
	
	#if we're at our target move other way
	if position.x == targetX:
		if targetX == startX:
			targetX = position.x + moveDist
		else:
			targetX = startX
			

func move_to(current, to, step):
	var new = current
	
	#moving positive?
	if new < to:
		new += step
		
		if new > to:
			new = to
			
	#moving negative?
	else:
		new -= step
		
		if new < to:
			new = to
	
	return new
