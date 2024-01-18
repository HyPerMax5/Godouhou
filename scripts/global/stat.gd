extends Node

var lives:int = 3
var graze:int
var score:int

var collision_dict = {
	"World" : 0b1,
	"Player" : 0b10,
	"Player Graze" :  0b100,
	"Player Hurtbox" : 0b1000,
	"Hostile" : 0b10000,
	"Hostile Hitbox" : 0b100000,
	"Hostile Hurtbox" : 0b1000000,
	"Player&Graze" : 0b1001,
}


func _ready() -> void:
	pass
	
