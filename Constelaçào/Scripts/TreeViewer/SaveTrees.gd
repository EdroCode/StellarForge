extends MenuButton

@onready var save_dialog = $"../../../../SaveDialog"
@onready var load_dialog = $"../../../../LoadDialog"


# Called when the node enters the scene tree for the first time.
func _ready():
	
	get_popup().id_pressed.connect(_on_menu_button_pressed)
	load_dialog.file_selected.connect(_on_file_selected)
	
	save_dialog.visible = false
	load_dialog.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_menu_button_pressed(id : int) -> void:
	match id:
		0: load_dialog.popup()
		3: save_dialog.popup()

func _on_file_selected(path: String):
	
	load_game(path)


func save(tree_name):
	
	
	var path = ("res://Saves/Trees/" + tree_name)
	print(path)
	var save_file = FileAccess.open(path, FileAccess.WRITE)
	var save_nodes = get_tree().get_nodes_in_group("Persist")

	for node in save_nodes:
		
		# Check the node is an instanced scene so it can be instanced again during load.
		if node.scene_file_path.is_empty():
			print("persistent node '%s' is not an instanced scene, skipped" % node.name)
			continue

		# Check the node has a save function.
		if !node.has_method("save"):
			print("persistent node '%s' is missing a save() function, skipped" % node.name)
			continue

		# Call the node's save function.
		var node_data = node.call("save")

		# JSON provides a static method to serialized JSON string.
		var json_string = JSON.stringify(node_data)

		# Store the save dictionary as a new line in the save file.
		save_file.store_line(json_string)
		
	
	#$"../Warning".text = "Game saved in " + str(save_file)

func load_game(file_path):
	var save_file = FileAccess.open(file_path, FileAccess.READ)
	while save_file.get_position() < save_file.get_length():
		var json_string = save_file.get_line()

		var json = JSON.new()
		var parse_result = json.parse(json_string)
		if parse_result != OK:
			print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
			continue

		var node_data = json.data
		var new_object = load(node_data["filename"]).instantiate()

		# Generate a random position for each instance
		var pos = Vector2(randf_range(100, get_window().size.x - 100), randf_range(100, get_window().size.y - 100))
		print("Spawning at: ", pos)  # Debugging print

		$"../../../../SkillTrees".add_child(new_object)
		await get_tree().process_frame  # Ensure proper positioning update

		if new_object.is_in_group("Tree"):
			if new_object is Control:
				new_object.rect_position = pos
			else:
				new_object.position = pos

			new_object.tree_name = node_data["title"]
			
		

	




func _on_save_dialog_confirmed():
	print("Player clicked to save")




