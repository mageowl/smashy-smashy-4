extends StaticBody2D

const WIDTH := 280.0
const CHUNK_SIZE := 40

var shrink_time := 0.0

func _process(delta: float) -> void:
	var avg_offset := 0.0
	
	var bodies: Array[Node2D] = $Touching.get_overlapping_bodies()
	for body in bodies:
		avg_offset += body.position.x - position.x
	
	avg_offset /= max(bodies.size(), 1)
	
	var weight_angle: float = avg_offset / WIDTH * deg_to_rad(3)
	var weight_offset: float = 1 - abs(avg_offset) / WIDTH * 8
	if bodies.size() > 0: weight_offset += 3
	
	$ColorRect.rotation = weight_angle
	$ColorRect.position.y = weight_offset
	$Flash.rotation = weight_angle
	$Flash.position.y = weight_offset
	
	if shrink_time > 0:
		shrink_time -= delta
		Effects.screen_shake(3)
		
		if shrink_time <= 0:
			shrink_time = 0
			finish_shrink()

func _on_shrink() -> void:
	$ColorRect.scale.x -= CHUNK_SIZE / 280.0
	shrink_time = 1.0

func finish_shrink() -> void:
	var shape: RectangleShape2D = $CollisionShape2D.shape
	shape.size.x -= CHUNK_SIZE
	
	if shape.size.x <= 0:
		$ShrinkTimer.stop()
		visible = false
		$CollisionShape2D.disabled = true
	else:
		$Flash.scale.x -= CHUNK_SIZE / WIDTH
