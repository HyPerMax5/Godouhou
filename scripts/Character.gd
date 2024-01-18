extends CharacterBody2D


const SPEED = 300.0
var speed_multi = 0.25
var bullet = preload("res://scenes/shared/bullet1.tscn")
var dead:bool = false
var can_die:bool = true

@onready var bullet_origin = $"bullet-spawn"
@onready var bullet_parent = $"bullet-spawn/bullet-parent"
@onready var shoot_timer = $"shoot-timer"
@onready var graze_area = $Graze
@onready var death_area = $Death
@onready var collection_area = $Collection
@onready var sprite = $Sprite2D
@onready var audio = $AudioStreamPlayer

func _ready() -> void:
	self.add_to_group("Player")
	graze_area.add_to_group("Player Graze")
	death_area.add_to_group("Player Death")
	collection_area.add_to_group("Player Collection")


func _physics_process(_delta: float) -> void:
	var speed
	var direction = Input.get_vector("left", "right", "up", "down")
	velocity = velocity.normalized()
	if Input.is_action_pressed("slow_move"):
		speed = SPEED * speed_multi
	else:
		speed = SPEED
	velocity = direction * speed
	move_and_slide()
	
func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("shoot"):
		on_shoottimer_timeout()
		shoot_timer.start()
	elif  Input.is_action_just_released("shoot"):
		shoot_timer.stop()
		audio.stop()
	
func on_shoottimer_timeout() -> void:
	audio.pitch_scale = randf_range(0.47, 0.52)
	audio.play()
	var char_bullet := bullet.instantiate()
	char_bullet.collision = Stat.collision_dict["Hostile"]
	bullet_parent.add_child(char_bullet)
	char_bullet.global_transform = bullet_origin.global_transform


func invulnerable() -> void:
	dead = false
	start_flashing()
	
		
func start_flashing():
	var tween_time:float = 0.15
	var flash := 4
	print("Started flashing")
	var tween := get_tree().create_tween()
	for i in flash:
		tween.tween_property(sprite, "modulate", Color (0, 0, 0, 0), tween_time)
		tween.tween_property(sprite, "modulate", Color (1, 1, 1, 1), tween_time)
	await get_tree().create_timer(flash*tween_time).timeout
	can_die = true
	print(can_die)
	


func on_graze_body_entered(_body) -> void:
	await get_tree().create_timer(0.015).timeout
	if !dead:
		Stat.graze += 1
		Stat.emit_signal("graze_updated", Stat.graze)

func on_death_body_entered(_body) -> void:
	if can_die and Stat.lives > 0:
		Stat.lives -= 1
		Stat.emit_signal("lives_updated", Stat.lives)
		dead = true
		can_die = false
		invulnerable()
	elif can_die and Stat.lives == 0:
		#game_over
		Stat.emit_signal("lives_updated", Stat.lives)
		dead = true
		can_die = false
		self.queue_free()

func on_collected(item):
	print("got", item)
	pass
