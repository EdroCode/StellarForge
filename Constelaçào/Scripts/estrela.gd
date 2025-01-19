extends Node2D


var mouse_on_area : bool
var selectable : bool = false

@onready var warn_label = get_parent().get_parent().get_node("GUI/Control Menu/Warning")
@onready var parent = get_parent().get_parent()

enum STATES {IDLE, SELECTED, DRAG}

var s_size = "null"

var state_cur : int
var state_nxt : int
var state_prv : int

var anim_cur = ""
var anim_nxt = "idle"

var skill_name = ""
var skill_description = ""



# Called when the node enters the scene tree for the first time.
func _ready():
	state_cur = -1
	state_prv = -1
	state_nxt = STATES.IDLE
	




func _process(delta):
	
	if state_nxt != state_cur:
		state_prv = state_cur
		state_cur = state_nxt
	
	if anim_nxt != anim_cur:
		anim_cur = anim_nxt
		$AnimationPlayer.play(anim_cur)
	
	if s_size == "big":
		scale = Vector2(4.5, 4.5)
	elif s_size == "small":
		scale = Vector2(3, 3)
	
	match state_cur:
		
		STATES.IDLE:
			state_idle(delta)
		STATES.SELECTED:
			state_selected(delta)
		STATES.DRAG:
			state_drag(delta)
	


func initialize_idle():
	$Sprite.visible = false
	anim_nxt = "idle"
	state_nxt = STATES.IDLE

func state_idle(delta):
	
	$AnimationPlayer.play("idle")
	
	if mouse_on_area:
		$Sprite.visible = true
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
	anim_nxt = "selected"
	$Sprite.visible = true
	if parent.star_selected == false:
		parent.star_selected = true
	parent.selected_stars.append(self)
	parent.create_line(self)
	#print("A estrela " + name + " foi selecionada")
	update_skill()
	
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
	
	$AnimationPlayer.play("selected")
	
	$Sprite.visible = true
	if Input.is_action_just_pressed("Delete"):
		queue_free()
	if mouse_on_area:
		if parent.state_cur == 2:
			initialize_drag()
			
			
			pass
	
	


func initialize_drag():
	anim_nxt = "drag"
	state_nxt = STATES.DRAG
	$Sprite.visible = true

func state_drag(delta):
	$AnimationPlayer.play("drag")
	
	global_position = get_global_mouse_position()
	
	if Input.is_action_just_pressed("select"):
		global_position = get_global_mouse_position()
		initialize_idle()
		parent.dragging = false


func _on_click_check_mouse_entered():
	
	mouse_on_area = true
	$Sprite.visible = true


func _on_click_check_mouse_exited():
	
	mouse_on_area = false
	$Sprite.visible = false
	

@onready var skill_node = get_tree().get_first_node_in_group("SkillEdit")

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


@onready var info_code = get_random_string(randi_range(5,100))

func get_random_string(length: int) -> String:
	var alphabet = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]
	var random_string = ""
	
	for i in length:
		random_string += alphabet[randi() % alphabet.size()]
	
	return random_string




