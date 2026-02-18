class_name SoulSuckMove extends Move

const MAX_DISTANCE := 100.0

@export_custom(PROPERTY_HINT_NONE, "suffix:s") var length := 1.0
@export_custom(PROPERTY_HINT_NONE, "suffix:px/s") var speed := 100.0
@export_custom(PROPERTY_HINT_NONE, "suffix:px/s") var distance_strength := 50.0
@export_custom(PROPERTY_HINT_NONE, "suffix:px/s") var spit_force := Vector2(300, -200)

var time := 0.0

func _process(delta: float) -> void:
	
	if time > 0:
		for body: Node2D in $EffectArea.get_overlapping_bodies():
			if body is Fighter:
				if body != fighter and sign(body.global_position.x - fighter.global_position.x) == fighter.get_flip_sign():
					var dx := fighter.global_position.x - body.global_position.x
					var dy := fighter.global_position.y - body.global_position.y
					var force: float = speed + distance_strength * (1 - abs(dx) / MAX_DISTANCE)
					body.velocity.x = -(force) * fighter.get_flip_sign()
					body.velocity.y = max(abs(dy) * 0.1, speed / 2) * sign(dy)
					
					if abs(dx) <= 10 and abs(dy) <= 10:
						time = 0
						$SuckParticles.emitting = false
						_spit(body)
						return
		
		time -= delta
		if time <= 0:
			$SuckParticles.emitting = false
			fighter.set_velocity_scale(1)
			fighter.playing_move_anim = false
			fighter.lock_direction = false

func run_move() -> void:
	time = length
	$SuckParticles.emitting = true
	$SuckParticles.rotation = PI if fighter.get_flip() else 0.0
	fighter.set_velocity_scale(0.1)
	fighter.lock_direction = true

func _spit(body: Fighter) -> void:
	body.grabbed = true
	body.visible = false
	fighter.lock_direction = false
	fighter.set_velocity_scale(0.5)
	
	await fighter.play_move_anim(&"spit")
	
	body.grabbed = false
	body.visible = true
	body.position = fighter.position
	body.velocity = spit_force * Vector2(fighter.get_flip_sign(), 1) * body.attack_scale
	body.attack_scale *= 2
	
	fighter.set_velocity_scale(1)
