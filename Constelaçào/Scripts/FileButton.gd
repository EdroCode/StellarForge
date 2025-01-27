extends MenuButton

@onready var save_dialog = $"../../../SaveDialog"
@onready var load_dialog = $"../../../LoadDialog"

@onready var warn = $"../Warning"

var current_save = null

# Called when the node enters the scene tree for the first time.
func _ready():
	
	get_popup().id_pressed.connect(_on_menu_button_pressed)
	load_dialog.file_selected.connect(_on_file_selected)
	save_dialog.dir_selected.connect(dir_selected)
	
	save_dialog.visible = false
	load_dialog.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_menu_button_pressed(id : int) -> void:
	match id:
		0: load_dialog.popup()
		1: save()
		2: clear()
		3: save_dialog.popup()

func _on_file_selected(path: String):
	
	load_game(path)

func dir_selected(dir: String):
	
	print(dir)
	save_game(dir)
	pass

func save():
	var save_file
	$"../../SkillEdit".visible = false
	
	if current_save == null:
		save_file = FileAccess.open("res://Saves/session_save.cfg", FileAccess.WRITE)
	else:
		save_file = FileAccess.open(current_save, FileAccess.WRITE)
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
		
	
	$"../Warning".text = "Game saved in " + str(save_file)




# Note: This can be called from anywhere inside the tree. This function is
# path independent.
# Go through everything in the persist category and ask them to return a
# dict of relevant variables.
func save_game(path):
	
	$"../../SkillEdit".visible = false
	
	var save_file = FileAccess.open(path, FileAccess.WRITE)
	var save_nodes = get_tree().get_nodes_in_group("Persist")
	current_save = save_file
	print("Path selected: " + str(save_file))
	
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
		
	
		$"../Warning".text = "Game saved"


# Note: This can be called from anywhere inside the tree. This function
# is path independent.
func load_game(file_path):
	
	$"../../SkillEdit".visible = false	
	warn = ("Loading " + str(file_path))
	
	print("Save selected: " + str(file_path))

	# We need to revert the game state so we're not cloning objects
	# during loading. This will vary wildly depending on the needs of a
	# project, so take care with this step.
	# For our example, we will accomplish this by deleting saveable objects.
	clear()

	# Load the file line by line and process that dictionary to restore
	# the object it represents.
	var save_file = FileAccess.open(file_path, FileAccess.READ)
	while save_file.get_position() < save_file.get_length():
		var json_string = save_file.get_line()

		# Creates the helper class to interact with JSON.
		var json = JSON.new()

		# Check if there is any error while parsing the JSON string, skip in case of failure.
		var parse_result = json.parse(json_string)
		if not parse_result == OK:
			print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
			continue

		# Get the data from the JSON object.
		var node_data = json.data
		
		# Firstly, we need to create the object and add it to the tree and set its position.
		var new_object = load(node_data["filename"]).instantiate()
		get_node(node_data["parent"]).add_child(new_object)
		if new_object.is_in_group("Star"):
			new_object.position = Vector2(node_data["pos_x"], node_data["pos_y"])
			new_object.add_to_group(node_data["info_code"])
			new_object.check_texture(node_data["size"])
			new_object.skill_name = node_data["title"]
			new_object.skill_description = node_data["description"]
			
			$Timer.start()
			await $Timer.timeout
			$Timer.stop()
			
			
		
		if new_object.is_in_group("Line"):
			var s1 = get_tree().get_first_node_in_group(node_data["info_code1"])
			var s2 = get_tree().get_first_node_in_group(node_data["info_code2"])
			
			new_object.design = node_data["design"]
			new_object.parent.append(s1)
			new_object.parent.append(s2)
			
			
			$"../../../Music".play_sound("res://Resources/Sounds/click3.wav", 1.29, 5)
			
			$Timer.start()
			await $Timer.timeout
			$Timer.stop()
			#print("Line Spawned with parents = " + str(s1) + " and " + str(s2))
			



		# Now we set the remaining variables.
		for i in node_data.keys():
			if i == "filename" or i == "parent" or i == "pos_x" or i == "pos_y":
				continue
			new_object.set(i, node_data[i])
	
	$"../Warning".text = "Save has been full loaded " 
	
	


func clear():
	
	var nodes = get_tree().get_nodes_in_group("Persist")
	$"../../..".selected_star = null
	$"../../SkillEdit/Title".text = ""
	$"../../SkillEdit/Desc".text = ""
	$"../Warning".text = "The Canvas has been cleared " 
	
	for i in nodes:
		i.queue_free()




func _on_save_dialog_file_selected(path):
	print(path)
	save_game(path)


func _on_save_dialog_confirmed():
	print("Player clicked to save")




