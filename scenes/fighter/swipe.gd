extends Sprite2D

func _ready() -> void:
	offset.x = 20 * (-1 if flip_h else 1)
	$AnimationPlayer.play("swipe")
