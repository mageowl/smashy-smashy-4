class_name OptionsEnvironment extends WorldEnvironment

func _ready() -> void:
	print("ready")
	environment.adjustment_brightness = max(Options.brightness, 0.25)
	Options.option_changed.connect(_on_option_changed)

func _on_option_changed(option: StringName) -> void:
	print("changed")
	if option == &"brightness":
		environment.adjustment_brightness = max(Options.brightness, 0.25)
