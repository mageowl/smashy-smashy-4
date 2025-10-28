class_name HarpoonMove extends Move

const POINTS: Array[float] = [0.0, 0.75, 0.8, 1.0]

@export_custom(PROPERTY_HINT_NONE, "suffix:px") var length := 200.0
@export_custom(PROPERTY_HINT_NONE, "suffix:px/s") var throw_force := 200.0
@export_custom(PROPERTY_HINT_NONE, "suffix:px/s") var hit_force := 400.0
@export_custom(PROPERTY_HINT_NONE, "suffix:px/s") var up_force := 100.0

func set_fighter(value: Fighter) -> void:
	super(value)
	$ShapeCast2D.add_exception(value)

func run_move() -> void:
	$ShapeCast2D.target_position.x = length * fighter.get_flip_sign()
	$ShapeCast2D.force_shapecast_update()
	Effects.freeze_frame(0.2)
	
	var global_target: Vector2
	var target: Vector2
	if (
		$ShapeCast2D.is_colliding() \
		and sign($ShapeCast2D.get_collision_point(0).x - global_position.x) == fighter.get_flip_sign()
	):
		Effects.screen_shake(6)
		
		var body: CollisionObject2D = $ShapeCast2D.get_collider(0)
		global_target = body.global_position
		
		if body is Fighter:
			body.apply_force(Vector2(hit_force * fighter.get_flip_sign(), -up_force))
	else:
		Effects.screen_shake(3)
		global_target = global_position + $ShapeCast2D.target_position
	
	target = global_target - global_position
	$Line2D.visible = true
	$Line2D.points = POINTS.map(func(f: float) -> Vector2: return target * f)
	
	await Effects.freeze_frame_ended
	fighter.global_position = global_target
	if fighter.velocity.x < fighter.knockback_threshold: fighter.velocity = Vector2(throw_force * fighter.get_flip_sign(), -up_force)
	$Line2D.visible = false
