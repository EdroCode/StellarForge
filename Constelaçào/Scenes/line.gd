extends Line2D

var traced = preload("res://Artwork/line.png")
var flat = preload("res://Artwork/line-flat.png")

var p1
var p2

var parent = []
var design 


# Called when the node enters the scene tree for the first time.
func _ready():
	if design == "traced":
		texture = traced
	elif design == "flat":
		texture = flat


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	
	
	if parent.size() > 1:
		var first_instance = parent[0]
		var second_instance = parent[1]
		if is_instance_valid(first_instance) and is_instance_valid(second_instance):
			points[0] = first_instance.global_position
			points[1] = second_instance.global_position
		else:
			queue_free()

