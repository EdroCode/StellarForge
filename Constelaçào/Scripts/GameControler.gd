extends Node2D

enum STATES {ADD_STAR, ADD_LINE, MOVE_STARS, SELECT, NONE}

@onready var audio_manager = $Music

# References
@onready var warn_label = $"GUI/Control Menu/Warning"
var selected_stars = []
var star_selected : bool
var selected_star
var tool_selected
var dragging : bool
var star = preload("res://Scenes/estrela.tscn")
var line = preload("res://Scenes/line.tscn")

var state_cur : int
var state_nxt : int
var state_prv : int

# Drawing Options
var star_size = "small"
var line_mode 

func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		get_tree().quit() # default behavior
		
		var file = FileAccess.open("res://Saves/session_save.cfg", FileAccess.WRITE)
		file.store_buffer(PackedByteArray())  # This will clear the file by writing an empty string.
		file.close()
		

func _ready():
	$GUI/Vignete.visible = true
	state_cur = -1
	state_prv = -1
	state_nxt = STATES.NONE
	
	warn_label.text = ""
	initialize_none()

func _process(delta):
	#print(can_add_star())
	if state_nxt != state_cur:
		
		state_prv = state_cur
		state_cur = state_nxt
	#print(selected_star)
	
	$"GUI/Control Menu/Test".text = str(selected_stars)
	$GUI/Vignete.color.a -= 0.008
	match state_cur:
		
		STATES.NONE:
			state_none(delta)
		STATES.ADD_STAR:
			state_add_star(delta)
		STATES.ADD_LINE:
			state_add_line(delta)
		STATES.MOVE_STARS:
			state_move_stars(delta)
		STATES.SELECT:
			state_select_stars(delta)
	
	

func initialize_none():
	$"GUI/Control Menu/ToolsMenu/ColorPallete/TextureRect".visible = false
	dragging = false
	warn_label.text = ("Ferramenta Selecionada: None")
	state_nxt = STATES.NONE
	$GUI/SkillEdit.visible = false
	deselect()

func state_none(delta):
	pass

func initialize_add_star():
	dragging = false
	deselect()
	$GUI/SkillEdit.visible = false
	state_nxt = STATES.ADD_STAR
	warn_label.text = ("Ferramenta Selecionada: Criar Estrela")

func state_add_star(delta):
	
	pass


func _unhandled_input(event):
	if event.is_action_pressed("select"):
		if can_add_star():
			var pos = get_local_mouse_position()
			create_star(pos)
	if Input.is_action_just_pressed("CreateStar"):
		if state_cur != STATES.ADD_STAR:
			deselect()
			initialize_add_star()
	if Input.is_action_just_pressed("CreateLine"):
		if state_cur != STATES.ADD_LINE:
			deselect()
			initialize_add_line()
	if Input.is_action_just_pressed("MoveTool"):
		if state_cur != STATES.MOVE_STARS:
			deselect()
			initialize_move_stars()
	if Input.is_action_just_pressed("SelectTool"):
		if state_cur != STATES.SELECT:
			initialize_select_stars()
			deselect()
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		initialize_none()
		deselect()

func initialize_add_line():
	dragging = false
	deselect()
	$GUI/SkillEdit.visible = false
	state_nxt = STATES.ADD_LINE
	warn_label.text = ("Ferramenta Selecionada: Criar Linha")
	selected_stars.clear()

func state_add_line(delta):
	
	
	
	if selected_stars.size() > 2:
			selected_stars[1] = selected_stars[0]
			selected_stars[2] = selected_stars[1]
			selected_stars.remove_at(2)


func initialize_move_stars():
	deselect()
	state_nxt = STATES.MOVE_STARS
	warn_label.text = ("Ferramenta Selecionada: Mover")

func state_move_stars(delta):
	pass

func initialize_select_stars():
	dragging = false
	
	state_nxt = STATES.SELECT
	warn_label.text = ("Ferramenta Selecionada: Selecionar")

func state_select_stars(delta):
	dragging = false




func create_line():
	
	if state_cur == STATES.ADD_LINE:
		if selected_stars.size() == 2:
			spawn_line()
	

func create_star(pos):
	
	var s = star.instantiate()
	s.check_texture(star_size)
	s.position = pos
	$Stars.add_child(s)
	warn_label.text = ("Estrela Criada em " + str(pos))

func deselect():
	
	star_selected = false
	for node in $Stars.get_child_count():
		var child = $Stars.get_child(node)
		child.initialize_idle()


func spawn_line():
	
	
	
	var old_star
	old_star = selected_stars[1]
	
	var l = line.instantiate()
	l.parent.append(selected_stars[0])
	l.parent.append(selected_stars[1])
	
	for i in selected_stars:
		i.initialize_idle()
	
	l.design = line_mode
	
	selected_stars.clear()
	selected_stars.append(old_star)
	
	$Lines.add_child(l)
	deselect()
	warn_label.text = ""


func can_add_star():
	
	var p = get_global_mouse_position()
	
	if p.y > 48 and p.y < 540 and p.x > 0 and p.x < 960 and state_cur == 0:
		
		
		return true
	



#
# Barra de reputaçao
#




func _on_move_button_down():
	initialize_move_stars()


func _on_select_button_down():
	initialize_select_stars()


func _on_texture_rect_mouse_entered():
	#$".".initialize_none()
	pass


@onready var t = $"GUI/Control Menu/Warning/Timer"

func _on_warning_finished():
	if t != null:
		t.start()
		await t.timeout
		$"GUI/Control Menu/Warning".text = ""


