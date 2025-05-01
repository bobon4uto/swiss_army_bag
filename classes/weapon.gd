extends Area2D
class_name weapon


var wname : String = "gun"

var ammo : int = -1

var current_weap = 0
var damage = 0
var knockback =0
var dam_tip : Array = []
var animation_speed =1.0
const BASE_ANIM_SPEED =1.0



enum wprop {
	DAMAGE,
	KNOCKBACK,
	AMMO,
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


const possible_weapons = ["hand",
"ruler","protractor","spray","pokestick","computer mouse","stem","torch","garlic","synth","slingshot","guitar",
"accordion","door",

"gun", "sword", "mace","bow","bo wand","water scroll","fire scroll","wind scroll","earth scroll","phone","pike","brass knuckles",

"chainsaw","plazma sword","witch hunter","white nights","fire whip","keg","great greatsword",
"duck trigger",

"ancient scroll","merks",
"null dereference",
"black and white silver"]

const weap_dict = {
	#"name":[damage,knockback, ammo, type, hitsize,offset,shoot,swing,special,speed]
	"hand":[2,10,-1,[],Vector2(60,60),Vector2(0,-30),false,true,false,1.0],
	
	"ruler":[2,2,-1,[dam_type.SLASH],Vector2(60,180),Vector2(0,-60),false,true,false,0.5],
	"protractor":[2,2,-1,[dam_type.BLUNT],Vector2(60,60),Vector2(0,-30),false,true,false,1.5],
	"spray":[0,40,-1,[dam_type.ELEM],Vector2(60,60),Vector2(0,-30),true,false,false,2.0],
	"pokestick":[2,20,-1,[dam_type.LIGHT,dam_type.PIERCE],Vector2(60,180),Vector2(0,-60),false,true,false,0.5],
	"computer mouse":[4,2,-1,[dam_type.LIGHT,dam_type.BLUNT],Vector2(180,180),Vector2(0,-60),false,true,false,0.5],
	"stem":[2,2,-1,[dam_type.BLUNT],Vector2(60,180),Vector2(0,-60),false,true,false,0.5],
	"torch":[4,2,-1,[dam_type.ELEM],Vector2(60,180),Vector2(0,-60),false,true,false,0.6],
	"garlic":[20,1,17,[dam_type.MENT, dam_type.LIGHT],Vector2(60,60),Vector2(0,-30),true,false,true,2.0],
	"synth":[10,2,-1,[dam_type.MENT],Vector2(60,180),Vector2(0,-60),false,true,false,0.1],
	"slingshot":[2,10,25,[dam_type.LIGHT,dam_type.BLUNT],Vector2(60,60),Vector2(0,-30),true,false,false,2.0],
	"guitar":[2,2,-1,[dam_type.MENT,dam_type.SLASH],Vector2(60,180),Vector2(0,-60),false,true,false,0.5],
	"accordion":[2,100,5,[dam_type.MENT,dam_type.BLUNT],Vector2(60,60),Vector2(0,-30),true,false,false,0.3],
	"door":[20,2,-1,[dam_type.BLUNT,dam_type.HEAVY],Vector2(180,180),Vector2(0,-60),false,true,false,0.1],
	
	
	"gun":[10,10,17,[dam_type.PIERCE],Vector2(60,60),Vector2(0,-30),true,false,false,2.0],
	"sword":[10,10,-1,[dam_type.SLASH],Vector2(60,180),Vector2(0,-60),false,true,false,0.5],
	"mace":[10,100,-1,[dam_type.BLUNT],Vector2(60,180),Vector2(0,-60),false,true,false,0.2],
	"bow":[30,30,50,[dam_type.PIERCE],Vector2(60,60),Vector2(0,-30),true,false,false,0.5],
	"bo wand":[10,100,-1,[dam_type.BLUNT, dam_type.LIGHT],Vector2(500,20),Vector2(0,-10),false,true,false,0.5],
	"water scroll":[10,20,10,[dam_type.ELEM, dam_type.LIGHT],Vector2(60,60),Vector2(0,-30),true,false,false,2.0],
	"fire scroll":[20,5,10,[dam_type.ELEM, dam_type.LIGHT],Vector2(60,60),Vector2(0,-30),true,false,false,2.0],
	"wind scroll":[10,200,10,[dam_type.ELEM, dam_type.LIGHT],Vector2(60,60),Vector2(0,-30),true,false,false,0.2],
	"earth scroll":[40,50,10,[dam_type.ELEM, dam_type.LIGHT],Vector2(60,60),Vector2(0,-30),true,false,false,0.1],
	"phone":[10,50,15,[dam_type.MENT, dam_type.LIGHT],Vector2(60,60),Vector2(0,-30),true,false,false,0.5],
	"pike":[15,50,-1,[dam_type.PIERCE],Vector2(60,410),Vector2(0,-120),false,true,false,0.5],
	"brass knuckles":[20,10,-1,[dam_type.BLUNT],Vector2(60,60),Vector2(0,-30),false,true,false,1.0],
	
	
	"chainsaw":[25,2,-1,[dam_type.SLASH],Vector2(100,270),Vector2(0,-150),false,true,false,0.5],
	"plazma sword":[30,2,-1,[dam_type.ELEM],Vector2(25,320),Vector2(0,-160),false,true,false,0.5],
	"witch hunter":[30,50,17,[dam_type.PIERCE, dam_type.MENT],Vector2(60,60),Vector2(0,-30),true,false,false,1.0],
	"white nights":[40,10,17,[dam_type.PIERCE, dam_type.LIGHT],Vector2(25,480),Vector2(0,-80),true,false,false,2.0],
	"fire whip":[2,2,-1,[dam_type.SLASH],Vector2(110,100),Vector2(15,-250),false,true,false,0.5],
	"keg":[20,1,17,[dam_type.BLUNT,dam_type.HEAVY],Vector2(60,60),Vector2(0,-30),true,false,true,2.0],
	"great greatsword":[10,10,-1,[dam_type.SLASH],Vector2(140,1000),Vector2(0,-500),false,true,false,1.0],
	"duck trigger":[0,1,17,[],Vector2(60,60),Vector2(0,-30),true,false,true,2.0],
	
	
	"ancient scroll":[50,100,-1,[dam_type.BLUNT, dam_type.ELEM],Vector2(975,150),Vector2(0,-75),false,true,false,0.5],
	"merks":[100,10,-1,[dam_type.BLUNT, dam_type.ELEM],Vector2(250,1340),Vector2(0,-90),false,true,false,1.0],
	"null dereference":[200,1,17,[dam_type.MENT,dam_type.HEAVY],Vector2(60,60),Vector2(0,-30),true,false,true,2.0],
	
	"black and white silver":[50,10,30,[dam_type.PIERCE, dam_type.MENT],Vector2(60,60),Vector2(0,-30),true,false,true,2.0],
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
	set_weapon(0)
	shape.shape= shapet

func set_weapon(ID):
	current_weap=ID
	var namew : String= possible_weapons[current_weap] 
	wname = namew
	sprite.play(namew)
	var wprop_cur = weap_dict[namew]
	set_shape(wprop_cur[wprop.SIZE],wprop_cur[wprop.OFFSET])
	
	damage = wprop_cur[wprop.DAMAGE]
	knockback = wprop_cur[wprop.KNOCKBACK]
	ammo = wprop_cur[wprop.AMMO]
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
