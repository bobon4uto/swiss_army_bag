extends Area2D
class_name weapon

var current_weap = 0
var damage = 0
var knockback =0
var dam_tip : Array = []
var animation_speed =1.0
const BASE_ANIM_SPEED =1.0

const possible_weapons = ["gun", "sword", "mace"]

enum wprop {
	DAMAGE,
	KNOCKBACK,
	TYPE,
	SIZE,
	OFFSET,
	SHOOT,
	SWING,
	SPECIAL,
	ANIM_SPEED
}

enum dam_type {
	SLASH,
	BLUNT,
	PIERCE,
	
	LIGHT,
	HEAVY,
	
	ELEM,
	MENT
}

const weap_dict = {
	#"name":[damage,knockback type, hitsize,offset,shoot,swing,special]
	"gun":[10,0,[dam_type.PIERCE],Vector2(60,60),Vector2(0,-30),true,false,false,1.0],
	"sword":[10,10,[dam_type.SLASH],Vector2(60,180),Vector2(0,-60),false,true,false,0.5],
	"mace":[10,100,[dam_type.BLUNT],Vector2(60,180),Vector2(0,-60),false,true,false,0.2]
}

var shoot = false
var swing = true
var special = false
var shapet :RectangleShape2D
@onready var shape = $shape
@onready var sprite = $sprite


func _ready():
	body_entered.connect(_on_body_entered)
	shapet = RectangleShape2D.new()
	set_weapon(1)
	shape.shape= shapet

func set_weapon(ID):
	current_weap=ID
	var name : String= possible_weapons[current_weap] 
	sprite.play(name)
	var wprop_cur = weap_dict[name]
	set_shape(wprop_cur[wprop.SIZE],wprop_cur[wprop.OFFSET])
	
	damage = wprop_cur[wprop.DAMAGE]
	knockback = wprop_cur[wprop.KNOCKBACK]
	dam_tip = wprop_cur[wprop.TYPE]
	
	shoot= wprop_cur[wprop.SHOOT]
	swing = wprop_cur[wprop.SWING]
	special = wprop_cur[wprop.SPECIAL]
	
	animation_speed=wprop_cur[wprop.ANIM_SPEED]

func _on_body_entered(body):
	if body is enemy:
		body.handle_hit(damage,knockback,dam_tip)

func set_shape(size_t:Vector2,pos_t:Vector2):
	shapet.size=size_t
	shape.position = pos_t

func hflip(side : bool):
	sprite.flip_h=side
