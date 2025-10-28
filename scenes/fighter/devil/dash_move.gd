class_name DashMove extends Move

@export var strength := 400.0

func run_move() -> void:
	fighter.velocity.x = move_toward(
		fighter.velocity.x,
		strength * fighter.get_input_direction(),
		strength
	)
	fighter.velocity.y = 0
