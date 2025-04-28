extends Node2D

@onready var zickuza : player = $Zickuza
@onready var cam : Camera2D= %cam

func _input(event: InputEvent) -> void:
	zickuza.centre_look_at(cam.get_global_mouse_position())
