extends Path2D

var speed:int = 100000
var min_hostile:int = 1
var max_hostile:int = 15

@onready var spawn_timer = $"../spawn_timer"
var test_hostile:PackedScene = preload("res://scenes/hostile.tscn")

var path_follows = []
var progress_ratios = []

func _ready() -> void:
	spawn_hostiles()
	pass

func _process(_delta: float) -> void:
	pass


func _on_spawn_timer_timeout() -> void:
	pass

func spawn_hostiles():
	var hostiles_amount := randi_range(1, 15)
	for i in hostiles_amount:
		var path_follow := PathFollow2D.new()
		var hostile := test_hostile.instantiate()
		await get_tree().create_timer(3).timeout
		add_child(path_follow)
		path_follow.add_child(hostile)
		path_follow.loop = false
		path_follow.rotates = false
