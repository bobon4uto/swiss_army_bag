extends Node2D

@onready var door = $dorr

func _on_pass_body_entered(body: Node2D) -> void:
	if body is player:
		door.position = Vector2(0,200)


func _on_stop_body_entered(body: Node2D) -> void:
	if body is player:
		body.checkpoint = body.position
		door.position = Vector2(0,0)
		#body.health.value=body.MAX_HELTH
		
		
		
