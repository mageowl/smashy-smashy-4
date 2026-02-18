extends CanvasLayer

func _ready() -> void:
	_update_bg()
	Options.option_changed.connect(_on_option_changed)

func _on_option_changed(property: StringName) -> void:
	if property == &"high_contrast_bg" or property == &"disable_background_motion":
		print("update")
		_update_bg()

func _update_bg() -> void:
	if Options.disable_background_motion:
		if Options.high_contrast_bg:
			$TabContainer/Static.visible = true
		else:
			$TabContainer/StaticHighContrast.visible = true
	else:
		$TabContainer/Motion.visible = true
		$TabContainer/Motion/SubViewport/Cylinder.visible = !Options.high_contrast_bg
		$TabContainer/Motion/SubViewport/CylinderHighContrast.visible = Options.high_contrast_bg
