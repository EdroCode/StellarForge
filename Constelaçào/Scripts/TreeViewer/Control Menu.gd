extends Control

@onready var sk_tree = preload("res://Scenes/skill_tree.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_skill_open_button_down():
	get_tree().change_scene_to_file("res://Scenes/main_base.tscn")


func _on_add_skill_tree_button_down():
	var s = sk_tree.instantiate()
	var pos = Vector2(randf_range(0,get_window().size.x), randf_range(0,get_window().size.y))
	s.position = pos
	$"../../SkillTrees".add_child(s)
	
	

