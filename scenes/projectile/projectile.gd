@abstract
class_name Projectile extends CharacterBody2D

@export_custom(PROPERTY_HINT_NONE, "suffix:px/s") var speed := 300.0
@export_custom(PROPERTY_HINT_NONE, "suffix:speed/s") var acceleration := 100.0

var facing: int
var fighter: Fighter

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_collision_exception_with(fighter)
	facing = fighter.get_flip_sign()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	velocity.x = move_toward(velocity.x, speed * facing, speed * acceleration * delta)
	var prev_velocity := velocity + Vector2(0, -100)
	move_and_slide()
	
	if get_slide_collision_count() > 0:
		for i in range(0, get_slide_collision_count()):
			var body := get_slide_collision(i).get_collider()
			if body is Fighter:
				_on_hit_fighter(body, prev_velocity)
		
		_before_destroy(true)
		queue_free()
		return
	
	var in_rect := get_viewport_rect().grow(16)
	for player: Fighter in Game.get_players():
		in_rect.expand(player.position)
	
	if not in_rect.has_point(position):
		_before_destroy(false)
		queue_free()

@abstract func _on_hit_fighter(body: Fighter, prev_velocity: Vector2) -> void

@warning_ignore("unused_parameter")
func _before_destroy(hit: bool) -> void:
	pass
