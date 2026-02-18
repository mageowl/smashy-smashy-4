class_name HoverMove extends Move

@export_custom(PROPERTY_HINT_NONE, "suffix:px/s") var end_boost := 100.0

var ground_boost := false
var has_hover := true
var hovering := false

func _process(_delta: float) -> void:
	if hovering:
		if ground_boost and fighter.velocity.y >= 0:
			fighter.gravity_scale = 0.1
			ground_boost = false
		
		if (
			fighter.cooldown <= 0
			or fighter.input.is_special_just_released()
			or fighter.input.is_attack_just_pressed()
		):
			ground_boost = false
			fighter.gravity_scale = 1
			hovering = false
			fighter.set_cooldown(0)
			fighter.velocity.y = -end_boost
			$GPUParticles2D.emitting = false
			
			fighter.playing_move_anim = false
	
	if fighter.is_on_floor():
		has_hover = true

func run_move() -> void:
	has_hover = false
	hovering = true
	$GPUParticles2D.emitting = true
	
	if fighter.is_on_floor():
		ground_boost = true
		fighter.velocity.y = -fighter.jump_velocity * 0.9
	else:
		ground_boost = false
		fighter.velocity.y = 0
		fighter.gravity_scale = 0.1

func can_run_move() -> bool:
	return has_hover
