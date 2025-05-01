extends Area2D
class_name bullet

var velocity :Vector2 = Vector2.ONE
var speed = 10.0
var hitnum:int=1
var wname = "default"
@onready var sprite : AnimatedSprite2D = $sprite

func _ready() -> void:
	sprite.play(wname)
	look_at(position+velocity)

func _process(delta: float) -> void:
	position = position.move_toward(position+velocity,delta*speed)



func _on_timer_timeout() -> void:
	queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body is enemy:
		if hitnum <= 1:
			queue_free()
		else:
			hitnum-=1


func _on_body_exited(body: Node2D) -> void:
	if body is enemy:
		if hitnum <= 1:
			queue_free()
