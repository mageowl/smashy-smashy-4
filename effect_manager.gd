extends Node

signal freeze_frame_ended

const TRANSITION = preload("uid://d08jmb4l28u7o")

# px/s
const SHAKE_DECAY := 50
const SHAKE_INTENSITY := 1.0

var screen_shake_amount: float
var camera: Camera2D
var transition: TransitionRect
var _is_in_freeze_frame := false

func _enter_tree() -> void:
	transition = TRANSITION.instantiate()
	add_child(transition)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if screen_shake_amount > 0:
		camera.offset = Vector2(
			randf_range(-screen_shake_amount, screen_shake_amount),
			randf_range(-screen_shake_amount, screen_shake_amount)
		)
		
		screen_shake_amount -= delta * SHAKE_DECAY
		if screen_shake_amount <= 0:
			screen_shake_amount = 0
			camera.offset = Vector2.ZERO

func screen_shake(magnitude: float) -> void:
	screen_shake_amount = max(screen_shake_amount, magnitude * SHAKE_INTENSITY)

func freeze_frame(duration: float) -> void:
	_is_in_freeze_frame = true
	Engine.time_scale = 0.01
	await get_tree().create_timer(duration, true, false, true).timeout
	Engine.time_scale = 1
	freeze_frame_ended.emit()
	_is_in_freeze_frame = false

func set_camera(camera: Camera2D) -> void:
	self.camera = camera

func is_in_freeze_frame() -> bool:
	return _is_in_freeze_frame
