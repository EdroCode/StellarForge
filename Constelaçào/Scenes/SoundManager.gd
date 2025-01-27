extends Node

# Audio Files

@onready var audio_player = $AudioStreamPlayer

func _ready():
	
	pass


func _process(delta):
	pass


func play_sound(file, pitch, db):
	
	audio_player.stream = load(file)
	audio_player.volume_db = db
	audio_player.pitch_scale = pitch
	audio_player.play()
