extends Projectile

const FORCE_MULTIPLIER: Vector2 = Vector2(1.5, 1)

func _ready() -> void:
	super()
	$GPUParticles2D.rotation = PI / 2 * -fighter.get_flip_sign()

func _on_hit_fighter(body: Fighter, prev_velocity: Vector2) -> void:
	body.apply_force(prev_velocity * FORCE_MULTIPLIER)

func _before_destroy(hit: bool) -> void:
	$GPUParticles2D.emitting = false
	$GPUParticles2D.reparent(get_parent())
	if hit:
		Effects.screen_shake(5)
		Effects.freeze_frame(.1)
