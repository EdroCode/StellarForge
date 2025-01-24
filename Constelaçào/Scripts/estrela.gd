extends Node2D


var mouse_on_area : bool
var selectable : bool = false

@onready var warn_label = get_parent().get_parent().get_node("GUI/Control Menu/Warning")
@onready var parent = get_parent().get_parent()
@onready var arc = $Arc
@onready var star = $Star

@onready var skill_node = get_tree().get_first_node_in_group("SkillEdit")
@export var small_texture : CompressedTexture2D
@export var medium_texture : CompressedTexture2D
@export var big_texture : CompressedTexture2D

@export var small_arc : CompressedTexture2D
@export var medium_arc : CompressedTexture2D
@export var big_arc : CompressedTexture2D

@onready var info_code = get_random_string(randi_range(5,100))


enum STATES {IDLE, SELECTED, DRAG}

var s_size = "null"

var state_cur : int
var state_nxt : int
var state_prv : int

var anim_cur = ""
var anim_nxt = "idle"

var skill_name = ""
var skill_description = ""

var t = 0.0
var scale_min = Vector2(.7, .7)
var scale_max = Vector2(1.1, 1.1)


# Called when the node enters the scene tree for the first time.
func _ready():
	state_cur = -1
	state_prv = -1
	initialize_idle()
	check_texture(s_size)




func _process(delta):
	#print("State: ", state_cur, " Scale: ", scale, " Size: " , s_size, " Visibility: ", star.visible, " Current texture: ", $Star.texture)
	
	if state_nxt != state_cur:
		state_prv = state_cur
		state_cur = state_nxt
	
	
	match state_cur:
		
		STATES.IDLE:
			state_idle(delta)
		STATES.SELECTED:
			state_selected(delta)
		STATES.DRAG:
			state_drag(delta)
	


func initialize_idle():
	
	check_texture(s_size)
	arc.visible = false
	anim_nxt = "idle"
	state_nxt = STATES.IDLE 

func state_idle(delta):
	
	if mouse_on_area:
		arc.visible = true
		if Input.is_action_just_pressed("select"):
			if parent.state_cur == 1:
				initialize_selected()
			elif parent.state_cur == 2:
				if parent.dragging != true:
					initialize_drag()
					parent.dragging = true
			elif parent.state_cur == 3:
				initialize_selected()



func initialize_selected():
	
	check_texture(s_size)
	arc.visible = true
	if parent.star_selected == false:
		parent.star_selected = true
	parent.selected_stars.append(self)
	parent.create_line()
	update_skill()
	
	var current_scale_factor = (scale.x - scale_min.x) / (scale_max.x - scale_min.x)
	t = current_scale_factor
	
	if parent.state_cur == 3:
		if parent.selected_star == null:
			parent.selected_star = self
			get_tree().get_first_node_in_group("SkillEdit").open()
		else:
			parent.selected_star.initialize_idle()
			parent.selected_star = self
			get_tree().get_first_node_in_group("SkillEdit").open()
	state_nxt = STATES.SELECTED

func state_selected(delta):
	
	update_scale(delta)
	
	arc.visible = true
	if Input.is_action_just_pressed("Delete"):
		queue_free()
	if mouse_on_area:
		if parent.state_cur == 2:
			initialize_drag()


func initialize_drag():
	
	scale += Vector2(1,1)
	anim_nxt = "drag"
	state_nxt = STATES.DRAG
	arc.visible = true


func state_drag(delta):
	global_position = get_global_mouse_position()
	if Input.is_action_just_pressed("select"):
		global_position = get_global_mouse_position()
		initialize_idle()
		parent.dragging = false


func _on_click_check_mouse_entered():
	mouse_on_area = true
	arc.visible = true

func _on_click_check_mouse_exited():
	
	mouse_on_area = false
	arc.visible = false

func update_skill():
	
	skill_node.title_label.text = skill_name
	skill_node.description_label.text = skill_description

func save():
	var star_data = {
		"filename" : get_scene_file_path(),
		"parent" : get_parent().get_path(),
		"pos_x" : global_position.x,
		"pos_y" : global_position.y,
		"title" : skill_name,
		"description" : skill_description,
		"size" : s_size,
		"info_code" : info_code
	}
	return star_data

func get_random_string(length: int) -> String:
	var alphabet = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]
	var random_string = ""
	
	for i in length:
		random_string += alphabet[randi() % alphabet.size()]
	
	return random_string

func check_texture(size):
	s_size = size
	
	match s_size:
		
		"big":
			$Star.texture = big_texture
			$Arc.texture = big_arc
			scale = Vector2(4, 4)
			$Arc.scale = Vector2(.9, .9)
			
		"medium":
			$Star.texture = medium_texture
			$Arc.texture = medium_arc
			$Arc.scale = Vector2(.9, .9)
			scale = Vector2(3, 3)
		"small":
			$Star.texture = small_texture
			$Arc.texture = small_arc
			$Arc.scale = Vector2(1, 1)
			scale = Vector2(3, 3)
		_:
			$Star.texture = null 
			$Arc.texture = null
			$Arc.scale = Vector2(1,1)
			


func update_scale(delta):
	var scale_speed = 1.3
	
	t += delta / scale_speed 
	var scale_factor = abs(2.0 * (fposmod(t, 1.0)) - 1.0) 
	$Arc.scale = scale_min.lerp(scale_max, scale_factor) 
