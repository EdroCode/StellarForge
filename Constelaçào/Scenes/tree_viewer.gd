extends Node2D

func _ready():
	clear_trees()
	
	for save_file in get_save_files("res://Saves/Trees/"):
		print("Loading save file: ", save_file)
		$"GUI/Control Menu/HBoxContainer/FileButton".load_game(save_file)

func _process(delta):
	pass

func change_to_canvas():
	
	var trees_ids
	
	pass





func clear_trees():
	for child in $SkillTrees.get_children():
		child.queue_free()

func get_save_files(directory_path: String) -> Array:
	var save_files = []
	var dir = DirAccess.open(directory_path)
	
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		
		while file_name != "":
			if not dir.current_is_dir():
				save_files.append(directory_path.path_join(file_name))
			file_name = dir.get_next()
		
		dir.list_dir_end()
	else:
		print("Failed to open directory: ", directory_path)
	
	return save_files
