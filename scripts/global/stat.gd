extends Node
signal lives_updated(lives)
signal bombs_updated(bombs)
signal graze_updated(graze)
signal score_updated(score)
signal power_updated(power)


var lives:int = 3
var bombs:int = 2

var graze:int
var score:int
var power:int = 15
var max_power:int = 100

var collision_dict = {
	"World" : 0b1,
	"Player" : 0b10,
	"Player Graze" :  0b100,
	"Player Hurtbox" : 0b1000,
	"Hostile" : 0b10000,
	"Hostile Hitbox" : 0b100000,
	"Hostile Hurtbox" : 0b1000000,
	"Player Collector" : 0b10000000,
	"Player&Graze" : 0b1010,
	"Player&Collider" : 0b10000010,
}


func _ready() -> void:
	var max_bombs:int = 5
	var min_bombs:int = 0
	var max_lives:int = 5
	var min_lives:int = 0
	bombs = clampi(bombs, min_bombs, max_bombs)
	lives = clampi(lives, min_lives, max_lives)
	pass
	
