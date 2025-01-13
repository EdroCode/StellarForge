extends Control

@onready var title_label = $Title/LineEdit
@onready var description_label = $Label

var title
var description 
@onready var parent = $"../.."



#var description = 

# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_save_button_button_down():
	
	var s = parent.selected_star
	
	s.skill_name = title_label.text
	s.skill_description = description_label.text
	
	
	
	
