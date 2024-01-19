extends CharacterBody2D

var bullet = preload("res://scenes/shared/bullet1.tscn")
var death_sound = preload("res://assets/audio/sfx/hostile/death.ogg")

@onready var shoot_timer = $"Shoot-timer"
@onready var audio = $AudioStreamPlayer
var speed:float = 5
var kill_score:int = 100


func _ready() -> void:
	self.add_to_group("Hostile")
	pass
	
func _process(delta: float) -> void:
	var parent := self.get_parent()
	if parent.is_class("PathFollow2D"):
		parent.progress_ratio += speed * delta/100
		if parent.progress_ratio >= 1:
			print("freeing self")
			parent.queue_free()
	else:
		pass


func _on_shoottimer_timeout() -> void:
	var hostile_bullet := bullet.instantiate()
	hostile_bullet.add_to_group("Hostile")
	hostile_bullet.speed = -100
	hostile_bullet.collision = Stat.collision_dict["Player&Graze"]
	get_tree().get_root().add_child(hostile_bullet)
	hostile_bullet.global_position = self.global_position
	hostile_bullet.set_as_top_level(true)
	

func death() -> void:
	#death animation thing or smth
	shoot_timer.stop()
	audio.set_stream(death_sound)
	audio.play()
	Stat.score += kill_score
	Stat.score_updated.emit(Stat.score)
	var parent := self.get_parent()
	if parent.is_class("PathFollow2D"):
		parent.queue_free()
	else:
		self.queue_free()
	

func _on_audio_stream_player_finished() -> void:
	pass
