extends Node2D

@onready var zickuza : player = $Zickuza
@onready var cam : Camera2D= %cam
@onready var sp = $triggers/spawn_enemies
@onready var ea = $enemies
func _input(event: InputEvent) -> void:
	zickuza.centre_look_at(cam.get_global_mouse_position())


func _on_spawn_enemies_body_entered(body: Node2D) -> void:
	if body is player:
		spawn_enemies(sp.position,500,10,2)


func spawn_enemies(pos,range,num:int, stage:int):
	for i in range(num):
		spawn_enemy(sp.position,range,stage)

func spawn_enemy(pos:Vector2,range,stage:int):
	var new_enemy = preload("res://classes/zondbie.tscn").instantiate()
	new_enemy.position = pos + Vector2(randf()*2-1.0,randf()*2-1.0).normalized()*range
	new_enemy.start_pos= new_enemy.position
	new_enemy.zickuza=zickuza
	ea.add_child(new_enemy)


func _on_zickuza_retry() -> void:
	for en in ea.get_children():
		if en is enemy:
			en.position=en.start_pos
