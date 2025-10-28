extends Projectile

@export_custom(PROPERTY_HINT_NONE, "suffix:px/s") var force := Vector2(500, 100)

func _ready() -> void:
	super()
	$AnimationPlayer.play("play")
	if facing == -1:
		$GPUParticles2D.rotation = PI
		$Sprite.flip_h = true

func _on_hit_fighter(body: Fighter, _prev_velocity: Vector2) -> void:
	body.apply_force(force * Vector2(facing, 1))

func _before_destroy(hit: bool) -> void:
	$GPUParticles2D.emitting = false
	$GPUParticles2D.reparent(get_parent())
	if hit:
		Effects.screen_shake(5)
		Effects.freeze_frame(0.1)
