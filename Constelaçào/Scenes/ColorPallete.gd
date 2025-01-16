extends TextureButton

var current_color = ""
@onready var background = $"../../../../ColorRect"
@onready var hexLine = $TextureRect/HexChoose

var colors = ["#43434f","#606070","#7e7e8f","#c2c2d1","#8c3f5d","#ba6156","#eb564b","#f2a65e","#3ca370","#5dde87"
,"#6476e8","#86a7ed","#ffe478"]

var hex = "#43434f"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	background.color = hex
	if hex != null:
		$TextureRect/ColorButtons/ColorRect.color = hex
	



func _on_f_button_down():
	hex = colors[0]
	$"../../../..".warn_label.text = "Cor selecionada:" + hex
	

	


func _on_ffffeb_button_down():
	hex = colors[1]
	$"../../../..".warn_label.text = "Cor selecionada:" + hex


func _on_e_7e_8f_button_down():
	hex = colors[2]
	$"../../../..".warn_label.text = "Cor selecionada:" + hex



func _on_c_2c_2d_1_button_down():
	hex = colors[3]
	$"../../../..".warn_label.text = "Cor selecionada:" + hex


func _on_c_3f_5d_button_down():
	hex = colors[4]
	$"../../../..".warn_label.text = "Cor selecionada:" + hex



func _on_ba_6156_button_down():
	hex = colors[5]
	$"../../../..".warn_label.text = "Cor selecionada:" + hex



func _on_eb_564b_button_down():
	hex = colors[6]
	$"../../../..".warn_label.text = "Cor selecionada:" + hex



func _on_f_2a_65e_button_down():
	hex = colors[7]
	$"../../../..".warn_label.text = "Cor selecionada:" + hex



func _on_ca_370_button_down():
	hex = colors[8]
	$"../../../..".warn_label.text = "Cor selecionada:" + hex



func _on_dde_87_button_down():
	hex = colors[9]
	$"../../../..".warn_label.text = "Cor selecionada:" + hex
	


func _on_e_8_button_down():
	hex = colors[10]
	$"../../../..".warn_label.text = "Cor selecionada:" + hex
	


func _on_a_7_ed_button_down():
	hex = colors[11]
	$"../../../..".warn_label.text = "Cor selecionada:" + hex
	


func _on_ffe_478_button_down():
	hex = colors[12]
	$"../../../..".warn_label.text = "Cor selecionada:" + hex



func _on_check_button_button_down(): 
	
	
	hex = "#"+ hexLine.text
	$TextureRect/ColorButtons/ColorRect.color = hexLine.text
	$"../../../..".warn_label.text = "Cor selecionada:" + hex
	
