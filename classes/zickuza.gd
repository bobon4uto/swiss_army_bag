extends CharacterBody2D
class_name player

const SPEED = 500
@onready var anim : AnimationTree =$AnimationTree
@onready var sprite : AnimatedSprite2D = $BodySprite
@onready var hand = $centre/hand
@onready var weap = $centre/hand/weapon
var attacking = false
var facing_dir = Vector2.RIGHT
var bored = false
var available_weapons = 3

func _ready():
	hand.z_index=-1

func _physics_process(delta: float) -> void:
	velocity = handle_input() * SPEED
	
	anim.set("parameters/AnimationNodeStateMachine/swingspace/blend_position",facing_dir)
	anim.set("parameters/AnimationNodeStateMachine/idlespace/blend_position",facing_dir.x)
	move_and_slide()


func handle_input() -> Vector2:
	var motion = Vector2.ZERO
	if Input.is_action_pressed("ui_right"):
		motion.x+=1
		sprite.flip_h=false
		hand.z_index=-1
	if Input.is_action_pressed("ui_up"):
		motion.y+=-1
	if Input.is_action_pressed("ui_left"):
		motion.x+=-1
		sprite.flip_h=true
		hand.z_index=1
	if Input.is_action_pressed("ui_down"):
		motion.y+=1
	if motion != Vector2.ZERO:
		facing_dir=motion
	attacking= Input.is_action_pressed("attack")
	if Input.is_action_just_pressed("gacha"):
		weap.set_weapon(randi()%available_weapons)
		anim.set("parameters/TimeScale/scale",weap.animation_speed)
	
	
	bored = (!attacking) and facing_dir==Vector2.ZERO
	
	
	return motion.normalized()
