extends CharacterBody2D

var bullet = preload("res://scenes/shared/bullet1.tscn")

@onready var bullet_origin = $bullet_origin
@onready var bullet_parent = $bullet_origin/bullet_parent
@onready var shoot_timer = $"Shoot-timer"
var kill_score:int = 100

func _ready() -> void:
	self.add_to_group("Hostile")	
	pass
	
func _process(_delta: float) -> void:
	pass


func _on_shoottimer_timeout() -> void:
	var hostile_bullet := bullet.instantiate()
	hostile_bullet.speed = -1000
	hostile_bullet.collision = Stat.collision_dict["Player&Graze"]
	bullet_parent.add_child(hostile_bullet)
	hostile_bullet.global_transform = bullet_origin.global_transform
	


func on_hitbox_entered() -> void:
	#death animation thing or smth
	Stat.score += kill_score
	Stat.score_updated.emit(Stat.score)
	self.queue_free()
	pass
