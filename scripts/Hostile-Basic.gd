extends CharacterBody2D

var bullet = preload("res://scenes/shared/bullet1.tscn")
var death_sound = preload("res://assets/audio/sfx/hostile/death.ogg")

@onready var bullet_origin = $bullet_origin
@onready var bullet_parent = $bullet_origin/bullet_parent
@onready var shoot_timer = $"Shoot-timer"
@onready var audio = $AudioStreamPlayer
var kill_score:int = 100

func _ready() -> void:
	self.add_to_group("Hostile")
	pass
	
func _process(_delta: float) -> void:
	pass


func _on_shoottimer_timeout() -> void:
	var hostile_bullet := bullet.instantiate()
	hostile_bullet.add_to_group("Hostile")
	hostile_bullet.speed = -1000
	hostile_bullet.collision = Stat.collision_dict["Player&Graze"]
	bullet_parent.add_child(hostile_bullet)
	hostile_bullet.global_transform = bullet_origin.global_transform
	


func death() -> void:
	#death animation thing or smth
	audio.set_stream(death_sound)
	Stat.score += kill_score
	Stat.score_updated.emit(Stat.score)
	self.queue_free()
	pass


func _on_audio_stream_player_finished() -> bool:
	var finished = true
	return finished
