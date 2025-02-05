extends Node2D

var speed: float = 5.0
var target_position: Vector2

var unique_id: String
@onready var tree_name = "Skill Tree"

var can_wobble = false

func _ready():
	
	if unique_id == "" or unique_id == null:
		unique_id = generate_uuid()
	else:
		tree_name = $Name.text
	
	# Set the tree name with its unique identifier
	$Name.text = tree_name + unique_id 
	
	$WobbleTimer.start()
	await $WobbleTimer.timeout
	$WobbleTimer.queue_free()
	target_position = _get_random_position()
	can_wobble = true

func _process(delta):
	if can_wobble:
		
		
		position = position.move_toward(target_position, speed * delta)
		
		# If the node is close to the target position, set a new random target
		if position.distance_to(target_position) < 20.0:
			target_position = _get_random_position()

func _on_name_text_changed(new_text):
	tree_name = new_text


func _on_open_button_down():
	
	GameManager.selected_tree = self
	GameManager.tree_text = tree_name
	
	get_tree().change_scene_to_file("res://Scenes/main_base.tscn")


func save():
	var tree_data = {
		"filename": get_scene_file_path(),
		"parent": get_parent().get_path(),
		"pos_x": global_position.x,
		"pos_y": global_position.y,
		"title": tree_name,
		"unique_id": unique_id # Save the unique ID
	}
	return tree_data

func _get_random_position() -> Vector2:
	var viewport_size = get_viewport_rect().size
	return Vector2(
		randf_range(0, viewport_size.x),
		randf_range(0, viewport_size.y)
	)


# Function to generate a UUID-like unique string
func generate_uuid() -> String:
	var uuid = ""
	for i in 4:
		uuid += "%02x" % randi()  # Generates a hex-like identifier
	return uuid
