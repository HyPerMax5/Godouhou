extends Sprite2D

var speed:float = 1000
var collision
var shape = CircleShape2D.new()
var distance_travelled:float 

func _ready() -> void:
	distance_travelled = 1
	shape.radius = 3
	pass
	
func _process(delta: float) -> void:
	var distance := speed * delta
	var motion := -global_transform.y * speed * delta
	global_position += motion
	
	distance_travelled += distance
	var query := PhysicsShapeQueryParameters2D.new()
	query.set_shape(shape)
	query.collision_mask = collision
	query.transform = global_transform
	var result := get_world_2d().direct_space_state.intersect_shape(query, 1)
	
	for hit in result:
		if hit.collider.is_in_group("Player"):
			hit.collider.on_death_body_entered(null)
			queue_free()
		elif hit.collider.is_in_group("Hostile"):
			hit.collider.on_hitbox_entered()
			queue_free()
		elif hit.collider.is_in_group("Player Graze"):
			hit.collider.on_graze_body_entered()
	if distance_travelled > 1200:
		queue_free()
	
