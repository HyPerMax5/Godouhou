extends Sprite2D

var speed:float = 1000
var collision
var shape = CircleShape2D.new()
var distance_travelled:float 

func _ready() -> void:
	distance_travelled = 1
	shape.radius = 3

func _process(delta: float) -> void:
	var distance := speed * delta
	var motion := -global_transform.y * speed * delta
	global_position += motion
	
	distance_travelled += distance
	var query := PhysicsShapeQueryParameters2D.new()
	query.set_shape(shape)
	query.collision_mask = collision
	query.transform = global_transform
	query.collide_with_areas = true
	var result := get_world_2d().direct_space_state.intersect_shape(query, 1)
	
	for hit in result:
		print(result)
		if hit.collider.is_in_group("Player Death"):
			hit.collider.emit_signal("body_entered", null)
			queue_free()
		if hit.collider.is_in_group("Hostile"):
			hit.collider.on_hitbox_entered()
			queue_free()
		if hit.collider.is_in_group("Player Graze"):
			hit.collider.emit_signal("body_entered", null)
	if distance_travelled > 1200:
		queue_free()
	
