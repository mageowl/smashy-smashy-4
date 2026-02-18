@tool
extends HBoxContainer

@export var property := &""
@export var label := "Option" :
	set(v):
		label = v
		$Label.text = v
@export var max_value := 1.0 :
	set(v):
		max_value = v
		$HSlider.max_value = max_value

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var value: float = Options.get(property)
	
	$Label.text = label
	$Percent.text = str(int(value * 100)) + "%"
	$HSlider.value = value
	$HSlider.max_value = max_value

func _on_value_changed(value: float) -> void:
	$Percent.text = str(int(value * 100)) + "%"

func _on_h_slider_drag_ended(value_changed: bool) -> void:
	if value_changed:
		Options.set_option(property, $HSlider.value)
