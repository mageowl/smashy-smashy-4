extends Node

signal freeze_frame_ended

const TRANSITION = preload("uid://d08jmb4l28u7o")
const QUIT_PROMPT = preload("uid://crhp18airi8du")

# px/s
const SHAKE_DECAY := 50

var screen_shake_amount: float
var camera: Camera2D
var transition: TransitionRect
var _is_in_freeze_frame := false

func _enter_tree() -> void:
	transition = TRANSITION.instantiate()
	add_child(transition)
	add_child(QUIT_PROMPT.instantiate())

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if camera != null and not camera.is_inside_tree(): camera = null
	if screen_shake_amount > 0 and camera != null:
		camera.offset = Vector2(
			randf_range(-screen_shake_amount, screen_shake_amount),
			randf_range(-screen_shake_amount, screen_shake_amount)
		)
		
		screen_shake_amount -= delta * SHAKE_DECAY
		if screen_shake_amount <= 0:
			screen_shake_amount = 0
			camera.offset = Vector2.ZERO

func screen_shake(magnitude: float) -> void:
	screen_shake_amount = max(screen_shake_amount, magnitude * Options.screen_shake_multiplier)

func freeze_frame(duration: float) -> void:
	if Options.disable_freeze_frame: return
	
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
