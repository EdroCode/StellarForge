extends Control

@onready var title_label = $Title
@onready var description_label = $Desc

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
	



func open():
	
	#visible = !visible
	var selected_star = $"../..".selected_star
	
	
	if selected_star != null:
		if visible == true:
			visible = true
		else:
			visible = true
	
		
		if selected_star.skill_name != "" or selected_star.skill_description != "": 
			$Title.text = selected_star.skill_name
			$Desc.text = selected_star.skill_description
		else:
			print(str(selected_star) + " has no saved data")
			$Title.text = ""
			$Desc.text = ""
	else:
		
		if visible == true:
			visible = false
		else:
			visible = true


