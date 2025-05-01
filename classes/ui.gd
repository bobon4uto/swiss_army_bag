extends Control
@onready var trect : TextureRect = $rb/VBoxContainer/weapanel/AspectRatioContainer/TextureRect
@onready var wsprite : AnimatedSprite2D=$rb/VBoxContainer/weapanel/AspectRatioContainer/AnimatedSprite2D
@onready var hsprite : AnimatedSprite2D=$"lt/HBoxContainer/VBoxContainer/Zickuza panel/AspectRatioContainer/head"
func _ready() -> void:
	wsprite.position=trect.position
	wsprite.scale=trect.scale
	
