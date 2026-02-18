extends CanvasLayer

signal accepted

var open := false
var should_quit_app := false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		if open: _close()
		else:
			open = true
			show()
			%Yes.grab_focus()
			get_tree().paused = true
			$Panel.mouse_behavior_recursive = Control.MOUSE_BEHAVIOR_INHERITED
			
			should_quit_app = Effects.transition.history.is_empty()
			$Panel/Label.text = "Quit?" if should_quit_app else "Exit?"

func _on_no_pressed() -> void:
	_close()

func _on_yes_pressed() -> void:
	get_tree().paused = false
	visible = false
	open = false
	accepted.emit()
	if should_quit_app:
		await Effects.transition.anim_in()
		Effects.get_tree().quit()
	else:
		Effects.transition.go_back()
		Game.reset()

func _close() -> void:
	hide()
	open = false
	$Panel.release_focus()
	$Panel.mouse_behavior_recursive = Control.MOUSE_BEHAVIOR_DISABLED
	get_tree().paused = false
