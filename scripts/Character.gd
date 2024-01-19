extends CharacterBody2D


const SPEED = 250.0
var speed_multi = 0.25
var bullet = preload("res://scenes/shared/bullet1.tscn")
var dead:bool = false
var can_die:bool = true
var anim_speed:float = 5

var timer = 0
var update_frequency

@onready var shoot_timer = $"shoot-timer"
@onready var graze_area = $Graze
@onready var death_area = $Death
@onready var collection_area = $Collection
@onready var bomb_area = $Bomb
@onready var bomb_shape = $Bomb/CollisionShape2D
@onready var sprite = $Sprite2D
@onready var audio = $AudioStreamPlayer

func _ready() -> void:
	set_process(false)
	self.add_to_group("Player")
	graze_area.add_to_group("Player Graze")
	death_area.add_to_group("Player Death")
	collection_area.add_to_group("Player Collection")
	bomb_shape.set_disabled(true)
	
func _physics_process(_delta: float) -> void:
	update_frequency = lerpf(0.079, 0.025, float(Stat.power)/100)
	var speed
	var direction = Input.get_vector("left", "right", "up", "down")
	velocity = velocity.normalized()
	if Input.is_action_pressed("slow_move"):
		speed = SPEED * speed_multi
	else:
		speed = SPEED
	velocity = direction * speed
	move_and_slide()
	
func _process(delta:float) -> void:
	timer += delta
	if timer >= update_frequency:
		timer -= update_frequency
		audio.pitch_scale = randf_range(0.47, 0.52)
		audio.play()
		fire_bullet()
		if Stat.power >= 30:
			fire_bullet1()
			fire_bullet2()

func _unhandled_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("shoot"):
		set_process(true)
	elif  Input.is_action_just_released("shoot"):
		set_process(false)
		audio.stop()
		
	if Input.is_action_just_pressed("bomb"):
		if Stat.bombs != 0:
			bomb_duration()
			Stat.bombs -= 1
			Stat.emit_signal("bombs_updated", Stat.bombs)
			
		elif Stat.bombs == 0:
			pass

	
func fire_bullet():
	var char_bullet := bullet.instantiate()
	char_bullet.collision = Stat.collision_dict["Hostile"]
	add_child(char_bullet)
	char_bullet.set_as_top_level(true)
	char_bullet.global_position = position + Vector2(0, -40)
func fire_bullet1():
	var char_bullet := bullet.instantiate()
	char_bullet.collision = Stat.collision_dict["Hostile"]
	add_child(char_bullet)
	char_bullet.set_as_top_level(true)
	if Input.is_action_pressed("slow_move"):
		char_bullet.global_position = position + Vector2(-30, -40)
		#char_bullet.global_position = global_position.lerp(Vector2(-30, -40), delta * anim_speed)
	else:
		char_bullet.global_position = position + Vector2(-55, -40)
func fire_bullet2():
	var char_bullet := bullet.instantiate()
	char_bullet.collision = Stat.collision_dict["Hostile"]
	add_child(char_bullet)
	char_bullet.set_as_top_level(true)
	if Input.is_action_pressed("slow_move"):
		char_bullet.global_position = position + Vector2(30, -40)
	else:
		char_bullet.global_position = position + Vector2(55, -40)
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

func _on_bomb_body_entered(body: Node2D) -> void:
	if body.is_in_group("Hostile"):
		if body.has_method("death"):
			body.death()
		else:
			body.queue_free()

func bomb_duration() -> void:
	bomb_shape.set_disabled(false)
	await get_tree().create_timer(3).timeout
	bomb_shape.set_disabled(true)
