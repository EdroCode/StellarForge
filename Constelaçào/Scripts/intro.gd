extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#Mudar para Animaçcao
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		_on_timer_timeout()
	pass


func _on_timer_timeout():
	get_tree().change_scene_to_file("res://Scenes/tree_viewer.tscn")


