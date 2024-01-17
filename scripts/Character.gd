extends CharacterBody2D


const SPEED = 300.0
var speed_multi = 0.25
var bullet = preload("res://scenes/shared/bullet1.tscn")
var bullet_speed:int = 50
@onready var bullet_origin = $"bullet-spawn"

func _physics_process(delta: float) -> void:
	var speed
	var direction = Input.get_vector("left", "right", "up", "down")
	velocity = velocity.normalized()
	if Input.is_action_pressed("slow_move"):
		speed = SPEED * speed_multi
	else:
		speed = SPEED
	velocity = direction * speed
	move_and_slide()
	
	if Input.is_action_pressed("shoot"):
		var char_bullet = bullet.instantiate()
		add_child(char_bullet)
		char_bullet.global_transform = bullet_origin.global_transform
		#char_bullet.position += char_bullet.transform.x * bullet_speed * delta
