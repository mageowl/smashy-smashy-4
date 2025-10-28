class_name SpinMove extends Move

@export_custom(PROPERTY_HINT_NONE, "suffix:px/s") var force := 200.0
@export_custom(PROPERTY_HINT_NONE, "suffix:px/s") var lift := 200.0

var spin_time := 0.0

func set_fighter(new: Fighter) -> void:
	super(new)
	new.hit_by_force.connect(func () -> void:
		spin_time = 0)

func _physics_process(delta: float) -> void:
	if spin_time > 0:
		spin_time -= delta
		
		for body: Node2D in $Hurtbox.get_overlapping_bodies():
			if body is Fighter:
				if body != fighter:
					body.apply_force(fighter.velocity)
					fighter.velocity = Vector2.ZERO
					Effects.screen_shake(7)

func run_move() -> void:
	spin_time = 0.3
	Effects.screen_shake(3)
	
	if fighter.is_on_floor():
		fighter.velocity += Vector2(
			force * fighter.get_flip_sign(),
			-lift
		)
	else:
		fighter.velocity += Vector2(
			force * fighter.get_flip_sign(),
			lift
		)
