extends CharacterBody2D
class_name player

signal retry

const SPEED = 500
@onready var anim : AnimationTree =$AnimationTree
@onready var sprite : AnimatedSprite2D = $BodySprite
@onready var center = $actual_center
@onready var hand = %hand
@onready var weap = %weapon
@onready var health = %health
@onready var timer = $Timer
var checkpoint = Vector2(0,0)
var attacking = false
var shooting = false
var facing_dir = Vector2.RIGHT
var bored = false
var available_weapons = 3
var rclickmovement = Vector2.ZERO
var shot_landed = false
var retrying:bool=false
const MAX_HELTH = 100

func _ready():
	hand.z_index=-1
	anim.set("parameters/TimeScale/scale",weap.animation_speed)
	health.max_value = MAX_HELTH
	health.value = MAX_HELTH

func _physics_process(_delta: float) -> void:
	velocity = handle_input() * SPEED
	
	#anim.set("parameters/AnimationNodeStateMachine/swingspace/blend_position",facing_dir)
	anim.set("parameters/AnimationNodeStateMachine/idlespace/blend_position",facing_dir.x)
	move_and_slide()


func handle_input() -> Vector2:
	var motion = Vector2.ZERO
	if Input.is_action_pressed("ui_right"):
		motion.x+=1



	if Input.is_action_pressed("ui_up"):
		motion.y+=-1
	if Input.is_action_pressed("ui_left"):
		motion.x+=-1

		
	if Input.is_action_pressed("ui_down"):
		motion.y+=1
	if Input.is_action_pressed("rmove"):
		motion = rclickmovement
	if motion != Vector2.ZERO:
		facing_dir=motion
	attacking= Input.is_action_pressed("attack")
	if !shooting:
		shooting=attacking and weap.shoot
	if shooting:
		attacking = true
	if attacking:
		anim.set("parameters/TimeScale/scale",weap.animation_speed)
		
	else:
		anim.set("parameters/TimeScale/scale",weap.BASE_ANIM_SPEED)
	if Input.is_action_just_pressed("gacha"):
		weap.set_weapon(randi()%available_weapons)
		anim.set("parameters/TimeScale/scale",weap.animation_speed)
	
	if facing_dir.x>0:
		if !sprite.animation.contains("ZickuzaR"):
			sprite.play("ZickuzaR")
		hand.z_index=-1
	else:
		if !sprite.animation.contains("ZickuzaL"):
			sprite.play("ZickuzaL")
		hand.z_index=1
	bored = (!attacking) and facing_dir==Vector2.ZERO
	
	
	return motion.normalized()


func centre_look_at(pos:Vector2):
	if attacking:
		center.look_at(pos)
	else:
		center.rotation=0


func handle_hit(damage):
	health.value-=damage
	if health.value<1.0:
		restart()


func restart():
	position=checkpoint
	health.value=MAX_HELTH
	
	retrying = true

func _on_bullet_body_entered(body: Node2D) -> void:
	if !shot_landed: 
		if body is enemy:
			body.handle_hit(weap.damage,weap.knockback,weap.dam_tip)
		shot_landed=true
		%bullet.visible = false
func set_bvisf():
	%bullet.visible = false
func set_bvist():
	%bullet.visible = true
func _on_shoot_end():
	shooting=false
	shot_landed=false

func _on_timer_timeout() -> void:
	health.value+=0.5
	health.value=clamp(health.value,0,MAX_HELTH)
	if retrying:
		emit_signal("retry")
		retrying=false
