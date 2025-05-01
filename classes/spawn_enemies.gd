extends Area2D
class_name spawner

@export var rangen = 1.0
@export var num : int = 1
@export var stage : int = 1
@export var size = 1.0
@export var unlockweapons : int = 1
signal pls_spawn(body: Node2D, me:spawner)

func _on_body_entered(body: Node2D) -> void:
	emit_signal("pls_spawn",body,self)


func restart():
	set_deferred("collision_layer", 0)
	set_deferred("collision_mask", 0)

func start():
	set_deferred("collision_layer", 1)
	set_deferred("collision_mask", 1)
