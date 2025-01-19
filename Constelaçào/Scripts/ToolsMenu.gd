extends Container

@onready var controller = $"../../.."
var line_win_open : bool = false
var star_win_open : bool = false


var ad1 = preload("res://Artwork/1.png")
var ad2 = preload("res://Artwork/addgold.png")
var li1 = preload("res://Artwork/2.png")
var li2 = preload("res://Artwork/linegold.png")
var mv1 = preload("res://Artwork/3.png")
var mv2 = preload("res://Artwork/movegold.png")
var se1 = preload("res://Artwork/4.png")
var se2 = preload("res://Artwork/arrowgold.png")

var color = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	line_win("close")
	add_win("close")
	$ColorPallete/TextureRect.visible = false 

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if controller.state_cur == 0:
		$"1-Add".texture_normal = ad2
		$"2-Line".texture_normal = li1 
		$"3-Move".texture_normal = mv1
		$"4-Select".texture_normal = se1
	if controller.state_cur == 1:
		$"1-Add".texture_normal = ad1
		$"2-Line".texture_normal = li2
		$"3-Move".texture_normal = mv1
		$"4-Select".texture_normal = se1
	if controller.state_cur == 2:
		$"1-Add".texture_normal = ad1
		$"2-Line".texture_normal = li1 
		$"3-Move".texture_normal = mv2
		$"4-Select".texture_normal = se1
	if controller.state_cur == 3:
		$"1-Add".texture_normal = ad1
		$"2-Line".texture_normal = li1
		$"3-Move".texture_normal = mv1
		$"4-Select".texture_normal = se2
	if controller.state_cur == 4:
		$"1-Add".texture_normal = ad1
		$"2-Line".texture_normal = li1
		$"3-Move".texture_normal = mv1
		$"4-Select".texture_normal = se1



func _on_add_button_down():
	if star_win_open:
		add_win("close")
	else:
		add_win("open")
		if line_win_open:
			line_win("close")


func _on_line_button_down():
	
	if line_win_open:
		line_win("close")	
	else:
		line_win("open")
		if star_win_open:
			add_win("close")


func _on_small_button_down():
	add_win("close")
	controller.star_size = "small"
	$"../Warning".text = "Tamanho Selecionado: Pequeno"
	controller.initialize_add_star()

	
	#tamanho pequeno


func _on_big_button_down():
	add_win("close")
	controller.star_size = "big"
	$"../Warning".text = "Tamanho Selecionado: Grande"
	controller.initialize_add_star()
	#tamanho grande

func _on_fill_button_down():
	controller.line_mode = "flat"
	$"../Warning".text = "Linha Selecionada: Lisa"
	controller.initialize_add_line()
	line_win("close")
	controller.initialize_add_line()


func _on_traced_button_down():
	controller.line_mode = "traced"
	$"../Warning".text = "Linha Selecionada: Tracejada"
	controller.initialize_add_line()
	line_win("close")
	controller.initialize_add_line()


func add_win(toggle):
	
	if toggle == "open":
		star_win_open = true
		$"1-Add/Big".visible = true
		$"1-Add/Small".visible = true
	elif toggle == "close":
		star_win_open = false
		$"1-Add/Big".visible = false
		$"1-Add/Small".visible = false


func line_win(toggle):
	
	if toggle == "open":
		line_win_open = true
		$"2-Line/Fill".visible = true
		$"2-Line/Traced".visible = true
	elif toggle == "close":
		line_win_open = false
		$"2-Line/Fill".visible = false
		$"2-Line/Traced".visible = false










func _on_help_button_down():
	OS.alert("# Camera

DESATUALIZADO Beta 1.0

-Zoom In: +
-Zoom Out: -
-Mover: Setas

# Ferramentas

-1: Adicionar Estrela
-2: Adicionar Linha
-3: Mover 
-4: Eliminar

Clique direito > Voltar ao Modo normal ( sem ferramenta selecionada )")



func _on_skill_open_button_down():
	$"../../SkillEdit".open()




func _on_color_pallete_button_down():
	$ColorPallete/TextureRect.visible = !$ColorPallete/TextureRect.visible



func _on_plus_button_down():
	$"../../../Camera2D".zoom_in()


func _on_minus_button_down():
	$"../../../Camera2D".zoom_out()
