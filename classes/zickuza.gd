extends CharacterBody2D
class_name player

signal retry

const SPEED = 500
@onready var anim : AnimationTree =$AnimationTree
@onready var sprite : AnimatedSprite2D = $BodySprite
@onready var center = $actual_center
@onready var hand = %hand
@onready var weap = %weapon
@export var health : ProgressBar
@export var wlabel : Label
@export var comment : RichTextLabel
@export var UIweap : AnimatedSprite2D
@export var UIammo : Label
@onready var timer = $Timer
@onready var spl : AnimationPlayer= $splash
@onready var splspr = $weaponsplash
@onready var shootaudio : AudioStreamPlayer = $shootaudio
@onready var swingaudio : AudioStreamPlayer = $swingAudio
@onready var ding : AudioStreamPlayer =$ding
var checkpoint = Vector2(0,0)
var attacking = false
var shooting = false
var facing_dir = Vector2.RIGHT
var bored = false
var available_weapons = 4
var rclickmovement = Vector2.ZERO
var lastlook = Vector2.ONE
var shot_landed = false
var retrying:bool=false
const MAX_HELTH = 100
var bulleting = false



const comm = {
	#"name":[damage,knockback type, hitsize,offset,shoot,swing,special]
	"hand":"I'm not as commited as my teacher - George, but I can punch some faces.",
	"gun":"When mana runs out, I use bullets.",
	"sword":"Honestly, I dont get why they're so popular...",
	"duck trigger":"IT'S TIME TO PULL MY DUCK TRIGGER!"
}




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

func get_motion() -> Vector2:
	var motion : Vector2 = Vector2.ZERO
	
	if Input.is_action_pressed("ui_right"):
		motion.x+=1
	if Input.is_action_pressed("ui_up"):
		motion.y+=-1
	if Input.is_action_pressed("ui_left"):
		motion.x+=-1
	if Input.is_action_pressed("ui_down"):
		motion.y+=1
	

	
	motion = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down",0.1)
	
	if Input.is_action_pressed("rmove"):
		motion = mouse_pos_dir()
	
	
	return motion

func mouse_pos_dir() -> Vector2:
	return get_viewport().get_camera_2d().get_global_mouse_position() - position


func get_attack_dir(motion) -> Vector2:
	
	var look = Input.get_vector("look_left", "look_right", "look_up", "look_down",0.1)
	if Input.is_action_pressed("llook"):
		look = mouse_pos_dir()
	if look==Vector2.ZERO:
		look= motion
	return look

func handle_input() -> Vector2:
	var motion = get_motion()
	var look = get_attack_dir(motion)
	rclickmovement = look
	if look != Vector2.ZERO:
		lastlook = look
	
	if motion != Vector2.ZERO:
		facing_dir=motion
	
	attacking= Input.is_action_pressed("attack") or attacking
	

	
	if !shooting:
		shooting=Input.is_action_pressed("attack") and weap.shoot
	else:
		centre_look_at(Vector2.ZERO)
	if attacking:
		anim.set("parameters/TimeScale/scale",weap.animation_speed)
		
	else:
		anim.set("parameters/TimeScale/scale",weap.BASE_ANIM_SPEED)
	if Input.is_action_just_pressed("gacha"):
		set_weapon_in_hand(randi()%(available_weapons)+1)
		
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

func set_weapon_in_hand(id):
	weap.set_weapon(id)
	wlabel.text = weap.wname 
	comment.text = "it's a "+weap.wname + "."
	
	if comm.has(weap.wname):
		comment.text = comm[weap.wname]
	UIweap.play(weap.wname)
	splspr.play(weap.wname)
	spl.play("spl")
	
	if weap.ammo > 0:
		UIammo.text = "Uses left : "+ str(weap.ammo)
	else:
		UIammo.text = ""


func stop_attack():
	attacking=false

func centre_look_at(pos:Vector2):
	
	if rclickmovement.x>0:
		weap.sprite.flip_h = false
	else:
		weap.sprite.flip_h = true
	if pos.x >10:
		center.rotation=0
		return
	if pos==Vector2.ZERO:
		pos =position+rclickmovement
	center.look_at(pos)



func handle_hit(damage):
	health.value-=damage
	if health.value<1.0:
		restart()


func restart():
	position=checkpoint
	health.value=MAX_HELTH
	set_weapon_in_hand(0)
	var variant = randi()%3
	match (variant):
		0:
			comment.text = "Oops, I died, silly me! What? Why am I alive again? Nanoma- I,m kidding, company secret."
		1:
			comment.text = "I died. Did that hurt? Of course it did. Am I used to it? kind of."
		2:
			comment.text = "I died. Thank god silver sunrise pays my medical bills."
		3:
			comment.text = "I died. I feel like I'm in a hard videogame..."
		4:
			comment.text = "I died. Don't worry, I won't become undead."


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

func on_bullet_hit(body):
	if body is enemy:
		body.handle_hit(weap.damage,weap.knockback,weap.dam_tip)

func call_swing():
	swingaudio.play()

func shoot_bullet():
	if (weap.ammo > 0):
		weap.ammo-=1
		if weap.ammo > 0:
			UIammo.text = "Uses left : "+ str(weap.ammo)
		else:
			UIammo.text = ""
	else:
		set_weapon_in_hand(0)
		return
	var new_bullet = preload("res://classes/bullet.tscn").instantiate()
	
	if weap.special:
		if weap.name.contains("black and white silver"):
			ding.play()
		else:
			shootaudio.play()
	else:
		shootaudio.play()
	
	if rclickmovement != Vector2.ZERO:
		new_bullet.velocity=rclickmovement*100000
	else: 
		new_bullet.velocity=lastlook*100000
	new_bullet.position = position
	new_bullet.speed = weap.animation_speed * 1000
	new_bullet.wname=weap.wname
	new_bullet.hitnum=int(floor( weap.knockback))
	new_bullet.scale = Vector2.ONE* weap.knockback/4
	new_bullet.connect("body_entered",on_bullet_hit)
	get_parent().add_child(new_bullet)
