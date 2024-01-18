extends CanvasLayer


@onready var score_label = %ScoreLabel
@onready var highscore_label = %HighscoreLabel
@onready var lives_container = %Lives_container
@onready var bomb_container = %Bomb_container
@onready var fps_label = %FPS
@onready var delta_label = %Delta
@onready var graze_label = %Graze_count
@onready var powerbar = %Powerbar



func _ready() -> void:
	var stat = get_node("/root/Stat")
	stat.connect("lives_updated", on_lives_updated)
	stat.emit_signal("lives_updated", Stat.lives)
	
	stat.connect("graze_updated", on_graze_updated)
	stat.emit_signal("graze_updated", Stat.graze)
	
	stat.connect("bombs_updated", on_bombs_updated)
	stat.emit_signal("bombs_updated", Stat.bombs)
	
	stat.connect("score_updated", on_score_updated)
	
	pass

func _process(delta: float) -> void:
	var fps := Engine.get_frames_per_second()
	var delta_display := delta*10000
	delta_display = snapped(delta_display, 0.1)
	fps_label.text = str(fps) + " fps"
	delta_label.text = str(delta_display) + " delta"
	pass


func on_lives_updated(lives):
	var life_scene := preload("res://scenes/ui/life.tscn")
	
	for child in lives_container.get_children():
		child.queue_free()
	for i in range(lives):
		var life := life_scene.instantiate()
		lives_container.add_child(life)
		
func on_bombs_updated(bombs):
	var bomb_scene := preload("res://scenes/ui/bomb.tscn")
	
	for child in bomb_container.get_children():
		child.queue_free()
	for i in range(bombs):
		var bomb := bomb_scene.instantiate()
		bomb_container.add_child(bomb)

func on_graze_updated(graze):
	graze_label.text = str(graze)

func on_score_updated(score):
	score_label.text = str(score)

func _on_progress_bar_value_changed(value: float) -> void:
	var max_value = powerbar.max_value 
	if value >= max_value:
		powerbar.get_child(0).visible = true
	else:
		powerbar.get_child(0).visible = false
