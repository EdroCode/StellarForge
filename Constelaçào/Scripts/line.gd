extends Line2D

@export var traced : AnimatedTexture
@export var flat : CompressedTexture2D

var p1
var p2

var parent = []
var design = "traced"


# Called when the node enters the scene tree for the first time.
func _ready():
	if design == "traced":
		texture = traced
	elif design == "flat":
		texture = flat
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if design == "traced":
		texture = traced
	elif design == "flat":
		texture = flat
	
	if parent.size() > 1:
		var first_instance = parent[0]
		var second_instance = parent[1]
		if is_instance_valid(first_instance) and is_instance_valid(second_instance):
			points[0] = first_instance.global_position
			points[1] = second_instance.global_position
		else:
			queue_free()

func save():
	
	
	var line_data = {
		"filename" : get_scene_file_path(),
		"parent" : get_parent().get_path(),
		"design" : design,
		"parent1" : parent[0].name,
		"parent2" : parent[1].name,
		"info_code1" : parent[0].info_code,
		"info_code2" : parent[1].info_code
		}
	return line_data
	
	
	
