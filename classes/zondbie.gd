extends RigidBody2D
class_name enemy

@export var zickuza : player
@export var speed = 400
@export var max_health = 100
@export var damage = 10
var effective :Array= []
var ineffective :Array= []
var start_pos = Vector2.ZERO
@export var stage : int = 2

@onready var body_sprite = $body
@onready var head_sprite = $head
@onready var weap_sprite = $weapoff
@onready var hat_sprite = $hat

@onready var health = $health
@onready var timer = $Timer
var dead = false


func _ready():
	generate()
	timer.start(1.0)
	timer.paused = true
	#collision_layer=0
	collision_mask=2
	start_pos=position

func generate():
	#max_health = randf_range(100*stage,100*stage*1.5)
	health.max_value=max_health
	health.value=max_health
	speed= randf_range(200*stage,200*stage*1.5)
	damage = randf_range(10*stage,10*stage*1.5)
	
	# TODO : make different eff ineff show up
	weapon.dam_type.SLASH
	
	var rand = randi()%(weapon.dam_type.MENT+1)
	effective.push_back(rand)
	body_sprite.play(str(rand))
	
	rand = randi()%(weapon.dam_type.MENT+1)
	effective.push_back(rand)
	head_sprite.play(str(rand))
	
	rand = randi()%(weapon.dam_type.MENT+1)
	ineffective.push_back(rand)
	hat_sprite.play(str(rand))
	
	rand = randi()%(weapon.dam_type.MENT+1)
	ineffective.push_back(rand)
	weap_sprite.play(str(rand))
	


func _process(delta: float) -> void:
	if dead:
		move_and_collide(Vector2.ZERO)
		collision_layer=0
		collision_mask=0
		return
	#look_at(zickuza.position)
	var velocity = ( zickuza.position -position).normalized() * speed*delta
	move_and_collide(velocity)



func handle_hit(damage, knockback, dam_types:Array):
	if dead:
		return
	var type_multi = 1.0
	
	for type in dam_types:
		for etype in effective:
			if type == etype:
				type_multi*=2
		for itype in ineffective:
			if type == itype:
				type_multi/=2

	
	position += (-zickuza.position+position).normalized() * knockback
	
	
	health.value-=damage*type_multi
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

func _on_hitbox_body_exited(body: Node2D) -> void:
	if dead:
		return
	timer.paused = true

func _on_hitbox_body_entered(body: Node2D) -> void:
	if dead:
		return
	if body is player:
		zickuza.handle_hit(damage)
		timer.paused=false
		


func _on_timer_timeout() -> void:
	if !dead:
		zickuza.handle_hit(damage)
	else:
		queue_free()
