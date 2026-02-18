extends Control

const NUM_BUTTONS = 2
enum ButtonId {
	PLAY = 0,
	OPTIONS = 1
}

var selected := ButtonId.PLAY
@onready var selector_mat: ShaderMaterial = %Selector.material

func _input(event: InputEvent) -> void:
	var new_selection: int
	if event.is_action_pressed("ui_up"):
		new_selection = selected - 1
	elif event.is_action_pressed("ui_down"):
		new_selection = selected + 1
	elif event.is_action_pressed("ui_accept"):
		_on_button_pressed(selected)
		return
	else: return
	
	if new_selection >= NUM_BUTTONS or new_selection < 0: return
	selected = new_selection as ButtonId

func _process(delta: float) -> void:
	var offset: Vector2 = selector_mat.get_shader_parameter("offset")
	selector_mat.set_shader_parameter("offset", offset.lerp(Vector2(0, selected * 14 + 1), delta * 24))

func _on_button_pressed(id: ButtonId) -> void:
	var next_scene: PackedScene
	match id:
		ButtonId.PLAY:
			next_scene = preload("uid://bsssija37vh53")
		ButtonId.OPTIONS:
			next_scene = preload("uid://b5gascewsrq70")
	
	Effects.transition.to_packed(next_scene)
