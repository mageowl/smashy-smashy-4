class_name SlamMove extends Move

@export_custom(PROPERTY_HINT_NONE, "suffix:px/s") var base_force := 300.0
## Force for every 50 pixels fallen.
@export_custom(PROPERTY_HINT_NONE, "suffix:px/s") var fall_force := 200.0
@export var bounce_strength_multiplier := 0.1

var current_attack_strength := 0.0

func set_fighter(new: Fighter) -> void:
	super(new)
	$Line2D.default_color = new.color

func run_move() -> void:
	current_attack_strength = base_force
	var particle_size := 12
	
	if not fighter.is_on_floor():
		var start_y := fighter.position.y
		var collision: KinematicCollision2D = null
		
		while collision == null and fighter.position.y < get_viewport_rect().size.y:
			collision = fighter.move_and_collide(Vector2(0, 50))
			current_attack_strength += fall_force
			particle_size += 1
		
		fighter.velocity.y = 0
		$Line2D.points[1].y = start_y - fighter.position.y
		$Line2D.visible = true
	
	Effects.screen_shake(particle_size - 12)
	Effects.freeze_frame(0.1)
	
	# Due to the Area2D code, we have to use signals *and* a for loop to handle the hurtbox.
	for body: Node2D in $Hurtbox.get_overlapping_bodies():
		if body is Fighter and body != fighter:
			_launch(body)
	
	for i in range(5):
		var direction: float = TAU / 2 + TAU / 8 * i
		var velocity := Vector2.from_angle(direction) * 100
		
		var xform := Transform2D(0, global_position + Vector2(0, 5))
		var flags := GPUParticles2D.EMIT_FLAG_POSITION | GPUParticles2D.EMIT_FLAG_VELOCITY | GPUParticles2D.EMIT_FLAG_ROTATION_SCALE
		
		$GPUParticles2D.emit_particle(xform, velocity, Color.WHITE, Color.TRANSPARENT, flags)
	
	await get_tree().create_timer(0.1, false, false, true).timeout
	fighter.velocity.y = -current_attack_strength * bounce_strength_multiplier
	$Line2D.visible = false
	current_attack_strength = 0

# Due to the Area2D code, we have to use signals *and* a for loop to handle the hurtbox.
func _on_hurtbox_body_entered(body: Node2D) -> void:
	if current_attack_strength <= 0: return
	if body is Fighter and body != fighter:
		_launch(body)


func _launch(body: Fighter) -> void:
	var victim: Fighter = body
	var force := (victim.position - fighter.position).normalized()
	force *= current_attack_strength
	force *= Vector2(1, 0.5)
	force -= Vector2(0, 150)
	body.apply_force(force)
