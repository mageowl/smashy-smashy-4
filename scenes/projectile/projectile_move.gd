class_name ProjectileMove extends Move

@export var scene: PackedScene

func _ready() -> void:
	top_level = true

func run_move() -> void:
	Effects.screen_shake(3)
	
	var proj: Projectile = scene.instantiate()
	proj.position = fighter.position + Vector2(fighter.get_flip_sign() * 15 + fighter.velocity.x * get_process_delta_time(), 0)
	proj.velocity.x = fighter.velocity.x
	proj.fighter = fighter
	add_child(proj)
