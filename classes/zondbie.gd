extends RigidBody2D
class_name enemy


@export var target : Vector2 = Vector2.ZERO
@export var speed = 400
@export var max_health = 100
@export var damage = 10

var effective :Array= [0]
var ineffective :Array= [0]
var start_pos = Vector2.ZERO
@export var stage : int = 2
@onready var body_sprite = $body
@onready var head_sprite = $head
@onready var weap_sprite = $weapoff
@onready var hat_sprite = $hat
@onready var att_sprite = $attack
@onready var htbx = $hitbox
@onready var health = $health
@onready var timer = $Timer
@onready var view = $view
@onready var hurts = $hurts
var dead = false


func _ready():
	generate()
	
	
	#collision_layer=0
	collision_mask=2
	start_pos=position

func rescale(vscale):
	for child in get_children():
		pass
		if child.has_method("set_scale"):
			child.set_scale(vscale)
		

func generate():
	#max_health = randf_range(100*stage,100*stage*1.5)
	
	effective.clear()
	ineffective.clear()
	health.max_value=max_health
	health.value=max_health
	speed= randf_range(200*stage,200*stage*1.5)
	damage = randf_range(10*stage,10*stage*1.5)
	
	
	var rcolor = Color(randf(),randf(),randf())
	var rand = randi()%(weapon.dam_type.MENT+1)
	effective.push_back(rand)
	body_sprite.play(str(rand))
	body_sprite.modulate = rcolor
	
	rand = randi()%(weapon.dam_type.MENT+1)
	effective.push_back(rand)
	head_sprite.play(str(rand))
	head_sprite.modulate = rcolor
	
	
	rand = randi()%(weapon.dam_type.MENT+1)
	ineffective.push_back(rand)
	hat_sprite.play(str(rand))
	hat_sprite.modulate = rcolor
	att_sprite.modulate =  rcolor
	rand = randi()%(weapon.dam_type.MENT+1)
	ineffective.push_back(rand)
	weap_sprite.play(str(rand))
	weap_sprite.modulate = rcolor
	timer.start(randf_range(0.5,2.0))


func _process(delta: float) -> void:
	if dead:
		move_and_collide(Vector2.ZERO)
		collision_layer=0
		collision_mask=0
		return
	#look_at(zickuza.position)
	att_sprite.visible = false
	var velocity = Vector2.ZERO
	if target != Vector2.ZERO:
		velocity = ( target -position).normalized() * speed*delta
	move_and_collide(velocity)



func handle_hit(damagen, knockback, dam_types:Array):
	if dead:
		return
	var type_multi = 1.0
	

	for type in dam_types:
		hurts.get_child(type).play()
		for etype in effective:
			if type == etype:
				type_multi*=2
		for itype in ineffective:
			if type == itype:
				type_multi/=2

	
	position += (-target+position).normalized() * knockback
	
	
	health.value-=damagen*type_multi
	if health.value<1.0:
		die()




func die():
	dead=true
	timer.paused=false
	timer.start(5.0)
	playdead()

func playdead():
	body_sprite.play("dead")
	head_sprite.play("dead")
	weap_sprite.play("dead")
	hat_sprite.play("dead")
	att_sprite.visible=false

func _on_hitbox_body_exited(_body: Node2D) -> void:
	if dead:
		return



func _on_hitbox_body_entered(_body: Node2D) -> void:
	if dead:
		return


func _on_timer_timeout() -> void:
	if !dead:
		att_sprite.visible = true
		for pl in htbx.get_overlapping_bodies():
			
			if pl is player:
				pl.handle_hit(damage)
		for pl in view.get_overlapping_bodies():
			if pl is player:
				target = pl.position
	else:
		queue_free()
