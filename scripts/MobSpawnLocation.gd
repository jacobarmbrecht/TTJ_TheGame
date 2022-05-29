extends Node2D

var rng = RandomNumberGenerator.new()

export (int) var LOW_OFFSET 	= -50
export (int) var HIGH_OFFSET 	= 50

var vector_position = Vector2(0,0)


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var rand_x = rng.randi_range(LOW_OFFSET, HIGH_OFFSET)
	vector_position = Vector2(rand_x,0)
	set_position(vector_position)
