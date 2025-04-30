extends Node2D

@onready var zickuza : player = $Zickuza
@onready var cam : Camera2D= %cam
@onready var sp = $triggers/spawn_enemies
@onready var ea = $enemies

func _ready():
	sp.monitoring = true
func _input(event: InputEvent) -> void:
	
	#zickuza.rclickmovement =( cam.get_global_mouse_position() - zickuza.position).normalized()
	if event is InputEventKey:
		
		if event.keycode == KEY_ESCAPE:
			spawn_enemy(zickuza.position,1000,2)


func _on_spawn_enemies_body_entered(body: Node2D) -> void:
	if body is player:
		spawn_enemies(sp.position,500,5,2)
		sp.set_deferred("collision_layer", 0)
		sp.set_deferred("collision_mask", 0)


func spawn_enemies(pos,rangen,num:int, stage:int):
	for i in range(num):
		call_deferred("spawn_enemy",pos,rangen,stage)
		#spawn_enemy(sp.position,range,stage)

func spawn_enemy(pos:Vector2,rangen,stage:int):
	var new_enemy = preload("res://classes/zondbie.tscn").instantiate()
	new_enemy.set_deferred("position", pos + Vector2(randf()*2-1.0,randf()*2-1.0).normalized()*rangen)
	new_enemy.start_pos= new_enemy.position
	new_enemy.stage = stage
	
	ea.add_child(new_enemy)
	new_enemy.generate()


func _on_zickuza_retry() -> void:
	for en in ea.get_children():
		if en is enemy:
			en.queue_free()
	sp.set_deferred("collision_layer", 1)
	sp.set_deferred("collision_mask", 1)
