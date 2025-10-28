extends CanvasLayer

signal accepted

@export var next_scene: PackedScene

var open := false

func _ready() -> void:
	if next_scene == null:
		$Panel/Label.text = "Quit?"

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		if open: _close()
		else:
			open = true
			show()
			%Yes.grab_focus()
			get_tree().paused = true

func _on_no_pressed() -> void:
	_close()

func _on_yes_pressed() -> void:
	get_tree().paused = false
	visible = false
	accepted.emit()
	if next_scene == null:
		await Effects.transition.anim_in()
		Effects.get_tree().quit()
	else:
		Effects.transition.to_packed(next_scene)

func _close() -> void:
	hide()
	open = false
	$Panel.release_focus()
	get_tree().paused = false
