extends Camera2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if Input.is_action_just_pressed("ZoomIn"):
		print($".".zoom)
		
		if $".".zoom < Vector2(3,3):
			$".".zoom += Vector2(0.2,0.2)
		else:
			$".".zoom = Vector2(3,3)
	if Input.is_action_just_pressed("ZoomOut"):
		print($".".zoom)
		if $".".zoom > Vector2(0.2,0.2):
			$".".zoom -= Vector2(0.2,0.2)
		else:
			$".".zoom = Vector2(0.2,0.2)
	
	
	if Input.is_action_pressed("ui_up"):
		offset.y -= 0.2
	if Input.is_action_pressed("ui_down"):
		offset.y += 0.2
	if Input.is_action_pressed("ui_left"):
		offset.x -= 0.2
	if Input.is_action_pressed("ui_right"):
		offset.x += 0.2
