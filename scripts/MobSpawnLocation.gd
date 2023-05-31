extends Node2D

var rng = RandomNumberGenerator.new()

export (int) var LOW_OFFSET 	= -100
export (int) var HIGH_OFFSET 	= 100

var vector_position = Vector2(0,-144)


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var rand_x = rng.randi_range(LOW_OFFSET, HIGH_OFFSET)
	vector_position = Vector2(rand_x,-144)
	set_position(vector_position)
