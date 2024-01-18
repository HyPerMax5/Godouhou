extends CharacterBody2D

var bullet = preload("res://scenes/shared/bullet1.tscn")

@onready var bullet_origin = $bullet_origin
@onready var bullet_parent = $bullet_origin/bullet_parent
@onready var shoot_timer = $"Shoot-timer"

func _ready() -> void:
	self.add_to_group("Hostile")	
	pass
	
func _process(_delta: float) -> void:
	pass


func _on_shoottimer_timeout() -> void:
	var hostile_bullet := bullet.instantiate()
	hostile_bullet.speed = -1000
	hostile_bullet.collision = Stat.collision_dict["Player"]
	bullet_parent.add_child(hostile_bullet)
	hostile_bullet.global_transform = bullet_origin.global_transform


func on_hitbox_entered() -> void:
	#death animation thing or smth
	self.queue_free()
	pass
