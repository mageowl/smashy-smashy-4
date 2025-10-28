extends Move

@export_custom(PROPERTY_HINT_NONE, "suffix:px/s") var force := 600.0
@export_custom(PROPERTY_HINT_NONE, "suffix:px/s") var lift := 100.0
@export_custom(PROPERTY_HINT_NONE, "suffix:px") var distance := 64.0

var target_position: Vector2

func run_move() -> void:
	var target: Fighter = null
	for body: Node2D in $Hurtbox.get_overlapping_bodies():
		if body is Fighter and body != fighter:
			target = body
			break
	
	var direction: Vector2
	if target != null:
		direction = (target.position - fighter.position).normalized()
	else:
		direction = Vector2(fighter.get_flip_sign(), 0)
	
	var offset := direction * distance
	fighter.position += offset
	
	$LandParticles.emitting = true
	$Line2D.points[1] = -offset
	$Line2D.visible = true
	
	Effects.screen_shake(6)
	Effects.freeze_frame(0.2)
	
	await Effects.freeze_frame_ended
	$Line2D.visible = false
	if not fighter.is_on_floor():
		fighter.velocity.y = -fighter.jump_velocity
	
	if target != null:
		target.apply_override_force(force * direction + Vector2(0, -lift))
