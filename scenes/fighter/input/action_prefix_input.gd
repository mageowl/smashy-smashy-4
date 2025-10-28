class_name ActionPrefixInput extends GenericInput

var prefix: String

func _init(prefix: String) -> void:
	self.prefix = prefix

func is_up_pressed() -> bool:
	return Input.is_action_pressed(prefix + "_up")

func is_down_pressed() -> bool:
	return Input.is_action_pressed(prefix + "_down")

func is_left_pressed() -> bool:
	return Input.is_action_pressed(prefix + "_left")

func is_right_pressed() -> bool:
	return Input.is_action_pressed(prefix + "_right")

func is_up_just_pressed() -> bool:
	return Input.is_action_just_pressed(prefix + "_up")

func is_down_just_pressed() -> bool:
	return Input.is_action_just_pressed(prefix + "_down")

func is_left_just_pressed() -> bool:
	return Input.is_action_just_pressed(prefix + "_left")

func is_right_just_pressed() -> bool:
	return Input.is_action_just_pressed(prefix + "_right")

func get_x_axis() -> float:
	return Input.get_axis(prefix + "_left", prefix + "_right")

func is_jump_pressed() -> bool:
	return Input.is_action_pressed(prefix + "_jump")

func is_jump_just_pressed() -> bool:
	return Input.is_action_just_pressed(prefix + "_jump")

func is_jump_just_released() -> bool:
	return Input.is_action_just_released(prefix + "_jump")

func is_attack_just_pressed() -> bool:
	return Input.is_action_just_pressed(prefix + "_attack")

func is_attack_just_released() -> bool:
	return Input.is_action_just_released(prefix + "_attack")

func is_special_just_pressed() -> bool:
	return Input.is_action_just_pressed(prefix + "_special")

func is_special_just_released() -> bool:
	return Input.is_action_just_released(prefix + "_special")

func is_accept_just_pressed() -> bool:
	return Input.is_action_just_pressed(prefix + "_accept")
