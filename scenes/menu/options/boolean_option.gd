@tool
extends HBoxContainer

@export var property := &""
@export var label := "Option" :
	set(v):
		label = v
		$Label.text = v

const UNCHECKED = preload("uid://bf6qx4ye5jwu1")
const CHECKED = preload("uid://d273kkejfh0d7")

var checked := false :
	set(v):
		checked = v
		$TextureRect.texture = CHECKED if v else UNCHECKED

func _ready() -> void:
	checked = Options.get(property)

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
			checked = !checked
			Options.set_option(property, checked)
