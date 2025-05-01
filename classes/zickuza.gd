extends CharacterBody2D
class_name player

signal retry

const SPEED = 500
var duck_mode = false
@onready var duck_timer : Timer =$DuckTimer
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
var available_weapons = 13
var rclickmovement = Vector2.ZERO
var lastlook = Vector2.ONE
var shot_landed = false
var retrying:bool=false
const MAX_HELTH = 100
var bulleting = false
var booming = false
var cutscene = false

const comm = {
	
	"hand":"I'm not as commited as my teacher - George, but I can punch some faces.",
"ruler":"Let's meusure the damage.",
"protractor":"I remember playing with that thing at school. never used it to measure angles though.",
"spray":"It's not holy water, so it's useless.",
"pokestick":"What am I supposed to poke them to death?",
"computer mouse":"A relic of the past.",
"stem":"Surprisingly good as a weapon.",
"torch":"Isn't it weird that torch damage counts as elemental magic? Like, there is nothing magical about a tourch. Eh, go figure.",
"garlic":"Yummy!",
"synth":"I'm very bad at music.",
"slingshot":"pew-pew.",
"guitar":"This guitar is si sharp I can cut down a tree with it!",
"accordion":"I'm not a pro at embedding musical instruments with magic.",
"door":"Not an arch, btw.",

"gun":"When mana runs out, I use bullets.",
"sword":"Honestly, I dont get why they're so popular...",
"mace":"Could be bigger.",
"bow":"Underrated weapon.",
"bo wand":"Isn't it just a long stck?",
"water scroll":"All water mages are quities. well, I'm judjing by my friends.",
"fire scroll":"I know one true fire mage. Its the only person I'm scared of.",
"wind scroll":"Wind mages are chill. But too hecking lazy.",
"earth scroll":"Do Earth mages even exist?",
"phone":"long time ago the biggest tech companies build THE TOURMENT NEXUS to unite all social medias. That was the catalyst for a demon invasion in 21st centry. But humanity won. and now THE TOURMENT NEXUS is installed on all mobile devices. do you want to sign up to THE TOURMENT NEXUS?",
"pike":"\"Give a peasant a pike, and he will defeat any army\" - some wise guy said some time ago.",
"brass knucles":"They're not actually brass.",

"chainsaw":"I dont have gas to power it...",
"plazma sword":"I thought they only come in red colors.",
"witch hunter":"Witches dont exist. Well, not as a species that is. so the name doesnt really make sense. but its still a great weapon, especially against vampires.",
"white nights":"OMG IS IT IS IT REALLY IT???? I WANT TO KEEP IT!!! Do you know what that is? Its a special crafted weapon by our equip team. I never have acces to such stuff, I'm just a healer after all, I get catfish swords and other nonsence.",
"fire whip":"I dont like where this is going.",
"keg":"Hope I wont blow up myself/",
"great greatsword":"Now THAT'S a sword.",
"duck trigger":"IT'S TIME TO PULL MY DUCK TRIGGER!",

"ancient scroll":"I can't read it.",
"merks":"It's the boots the old man gave me after I helped him. I directed them to the company because theyre a bit too big for me.",
"null dereference":"What could possibly go wrong?",
"black and white silver":"PEAK needs ping-ping"
	#"name":"commentary"

	
	
	
	
	
	
	
	
	
}




func _ready():
	hand.z_index=-1
	anim.set("parameters/TimeScale/scale",weap.animation_speed)
	health.max_value = MAX_HELTH
	health.value = MAX_HELTH
	#available_weapons = weapon.NOTWEAPONS

func _physics_process(_delta: float) -> void:
	if !cutscene:
		velocity = handle_input() * SPEED
	
	#anim.set("parameters/AnimationNodeStateMachine/swingspace/blend_position",facing_dir)
		anim.set("parameters/AnimationNodeStateMachine/idlespace/blend_position",facing_dir.x)
	
		if duck_timer.get_time_left()>0:
			UIammo.text = "time left = "+"%.2f" % duck_timer.get_time_left()
	else:
		velocity=Vector2.ZERO
	
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
		if duck_mode:
			if !sprite.animation.contains("duckR"):
				sprite.play("duckR")
			hand.z_index=-1
		else:
			if !sprite.animation.contains("ZickuzaR"):
				sprite.play("ZickuzaR")
			hand.z_index=-1
	else:
		if duck_mode:
			if !sprite.animation.contains("duckL"):
				sprite.play("duckL")
			hand.z_index=1
		else:
			if !sprite.animation.contains("ZickuzaL"):
				sprite.play("ZickuzaL")
			hand.z_index=1
	bored = (!attacking) and facing_dir==Vector2.ZERO
	
	
	return motion.normalized()

func set_weapon_in_hand(id):
	weap.set_weapon(id)
	wlabel.text = weap.wname 
	if duck_mode:
		pass
	else:
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
	if duck_mode:
		return
	health.value-=damage
	if health.value<1.0:
		restart()


func restart():
	position=checkpoint
	health.value=MAX_HELTH
	set_weapon_in_hand(0)
	var variant = randi()%5
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
		4:
			comment.text = "I died. But I survived!"


	retrying = true





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
	if weap.special:
		if weap.wname.contains("garlic") or weap.wname.contains("keg") or weap.wname.contains("null dereference"):
			attacking=false
	else:
		swingaudio.play()
	

func shoot_bullet():
	if weap.swing:
		return
	if (weap.ammo != 0):
		if !duck_mode:
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
		if weap.wname.contains( "black and white silver"):
			if weap.ammo <1:
				ding.pitch_scale = 0.5
				ding.stream.random_pitch = 1.0
			else: 
				ding.pitch_scale = 1.2
				ding.stream.random_pitch = 1.2
			ding.play()
		elif weap.wname.contains("garlic"):
			boom("garlic")
			set_weapon_in_hand(0)
			return
		elif weap.wname.contains("keg"):
			boom("keg")
			set_weapon_in_hand(0)
			return
		elif weap.wname.contains("null dereference"):
			boom("null dereference")
			set_weapon_in_hand(0)
			return
		elif weap.wname.contains("duck trigger"):
			pull_my_duck_trigger()
			set_weapon_in_hand(0)
			return
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
	new_bullet.hitnum=int(floor( weap.knockback/10))
	new_bullet.scale = Vector2.ONE* weap.knockback/40
	new_bullet.connect("body_entered",on_bullet_hit)
	get_parent().add_child(new_bullet)


func boom(n :String):
	var new_boom
	if  n.contains("garlic"):
		new_boom=preload("res://scenes/garlicboom.tscn").instantiate()
	elif n.contains("keg"):
		new_boom=preload("res://scenes/kegaboom.tscn").instantiate()
	elif n.contains("null dereference"):
		new_boom=preload("res://scenes/gpu_particles_2d.tscn").instantiate()
	else:
		return
	attacking=false
	for body in  %booms.get_overlapping_bodies():
		if body is enemy:
			body.handle_hit(weap.damage,weap.knockback,weap.dam_tip)
	
	$boom.play()
	add_child(new_boom)

func pull_my_duck_trigger():
	duck_mode = true
	duck_timer.start(15.0)

func _on_duck_timer_timeout() -> void:
	if cutscene:
		return
	duck_mode = false
	comment.text = "It was fun while it lasted."
