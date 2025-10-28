class_name PokeMove extends Move

const SWIPE = preload("uid://bgnv0hetj4js4")

@export_custom(PROPERTY_HINT_NONE, "suffix:px/s") var strength := 500.0
@export_custom(PROPERTY_HINT_NONE, "suffix:px/s") var lift := 400.0

func run_move() -> void:
	var swipe: Sprite2D = SWIPE.instantiate()
	swipe.position = fighter.position
	swipe.flip_h = fighter.get_flip()
	add_child(swipe)
	
	Effects.screen_shake(3)
	
	var do_freeze_frame := false
	for body: PhysicsBody2D in $Hurtbox.get_overlapping_bodies():
		if (
			body is Fighter
			and sign(body.position.x - fighter.position.x) == fighter.get_flip_sign()
		):
			body.apply_force(Vector2(
				strength * fighter.get_flip_sign(),
				fighter.velocity.y - lift,
			))
			do_freeze_frame = true
	
	if do_freeze_frame:
		Effects.freeze_frame(0.2)
