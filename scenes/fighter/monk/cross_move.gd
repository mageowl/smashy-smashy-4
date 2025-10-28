class_name CrossMove extends Move

@export_custom(PROPERTY_HINT_NONE, "suffix:s") var length := 1.0
@export_custom(PROPERTY_HINT_NONE, "suffix:s") var phase_charge_up := 0.3
@export_custom(PROPERTY_HINT_NONE, "suffix:s") var phase_cooldown := 0.6
@export_custom(PROPERTY_HINT_NONE, "suffix:px/s") var power := 300.0

var time := 0.0

func _process(delta: float) -> void:
	if time > 0:
		time -= delta
		if time <= 0:
			time = 0
			visible = false
		
		var color: Color
		var width: float
		
		if time > length - phase_charge_up:
			width = (1 - time) / phase_charge_up * 7
			color = Color.GRAY
		elif time <= phase_cooldown:
			fighter.set_velocity_scale(1)
			width = time / phase_cooldown * 20
			color = Color.DIM_GRAY
		else:
			Effects.screen_shake(6)
			width = 20
			color = fighter.color
		
		$Horizontal.width = width
		$Horizontal.default_color = color
		$Horizontal.position.y = fighter.position.y
		$Collider/HorizontalShape.position.y = fighter.position.y
		$Vertical.width = width
		$Vertical.default_color = color
		$Vertical.position.x = fighter.position.x
		$Collider/VerticalShape.position.x = fighter.position.x
		
		if time <= length - phase_charge_up and time > phase_cooldown:
			for body: PhysicsBody2D in $Collider.get_overlapping_bodies():
				if body is Fighter and body != fighter:
					body.apply_force((body.position - fighter.position) * power * delta)

func run_move() -> void:
	time = length
	visible = true
	fighter.set_velocity_scale(0.1)
