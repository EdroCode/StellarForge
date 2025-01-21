extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if $Timer.time_left > 2.5:
		$CanvasLayer/ColorRect2.color.a -= 0.0008
	else:
		$CanvasLayer/ColorRect2.color.a += 0.0008


func _on_timer_timeout():
	get_tree().change_scene_to_file("res://Scenes/main_base.tscn")
