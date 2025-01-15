extends Camera2D

var zoom_step: float = 0.1 # Amount to zoom in/out per step
var min_zoom: Vector2 = Vector2(0.5, 0.5) # Minimum zoom level
var max_zoom: Vector2 = Vector2(2, 2) # Maximum zoom level

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if Input.is_action_just_pressed("ZoomIn"):
		zoom_in()
	if Input.is_action_just_pressed("ZoomOut"):
		zoom_out()
	
	
	if Input.is_action_pressed("ui_up"):
		offset.y -= 0.2
	if Input.is_action_pressed("ui_down"):
		offset.y += 0.2
	if Input.is_action_pressed("ui_left"):
		offset.x -= 0.2
	if Input.is_action_pressed("ui_right"):
		offset.x += 0.2


func zoom_out():
	if zoom.x > min_zoom.x and zoom.y > min_zoom.y:
		zoom -= Vector2(zoom_step, zoom_step)
		zoom = zoom.clamp(min_zoom, max_zoom)

# Zoom out function
func zoom_in():
	if zoom.x < max_zoom.x and zoom.y < max_zoom.y:
		zoom += Vector2(zoom_step, zoom_step)
		zoom = zoom.clamp(min_zoom, max_zoom)
