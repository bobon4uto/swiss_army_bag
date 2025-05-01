extends Node2D

@onready var zickuza : player = $Zickuza
@onready var cam : Camera2D= %cam
#@onready var sp = $triggers/spawn_enemies
@onready var ea = $enemies
#@onready var te = $CanvasLayer/UI/TextEdit
@onready var trr =$triggers


func _ready():
	for child in trr.get_children():
		if child is spawner:
			child.connect("pls_spawn", _on_spawn_pls)

func  _process(_delta: float) -> void:
	var are_enemies_alive = false
	for enemem:enemy in ea.get_children():
		are_enemies_alive = !enemem.dead or are_enemies_alive
	if are_enemies_alive:
		zickuza.collision_layer = 1
		zickuza.collision_layer = 1
	else:
		zickuza.collision_layer = 5
		zickuza.collision_layer = 5

func _input(event: InputEvent) -> void:
	
	#zickuza.rclickmovement =( cam.get_global_mouse_position() - zickuza.position).normalized()
	if event is InputEventKey:
		
		if event.keycode == KEY_ESCAPE:
			spawn_enemy(zickuza.position,1000,2,1.0)




func spawn_enemies(pos,rangen,num:int, stage:int,size):
	for i in range(num):
		call_deferred("spawn_enemy",pos,rangen,stage,size)
		#spawn_enemy(sp.position,range,stage)

func spawn_enemy(pos:Vector2,rangen,stage:int,size):
	var new_enemy = preload("res://classes/zondbie.tscn").instantiate()
	new_enemy.set_deferred("position", pos + Vector2(randf()*2-1.0,randf()*2-1.0).normalized()*rangen)
	new_enemy.set_deferred("scale", size*Vector2.ONE)
	new_enemy.start_pos= new_enemy.position
	new_enemy.stage = stage
	new_enemy.rescale(Vector2.ONE*size)
	ea.add_child(new_enemy)
	new_enemy.generate()


func _on_zickuza_retry() -> void:
	for en in ea.get_children():
		if en is enemy:
			en.queue_free()
	trr.start()


func _on_button_pressed() -> void:
	pass
#	zickuza.set_weapon_in_hand(int(te.text)%weapon.possible_weapons.size())


func _on_text_edit_lines_edited_from(_from_line: int, _to_line: int) -> void:
#	zickuza.set_weapon_in_hand(int(te.text)%weapon.possible_weapons.size())
	pass


func _on_spawn_pls(body: Node2D, me:spawner) -> void:
	if body is player:
		spawn_enemies(me.position,me.rangen,me.num,me.stage,me.size)
		me.restart()
		body.available_weapons=me.unlockweapons

func start_cutscene():
	trr.start()


func _on_cutscenestarter_body_entered(body: Node2D) -> void:
	if body is player:
		start_cutscene()
