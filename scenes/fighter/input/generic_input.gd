@abstract
@icon("Game")
class_name GenericInput

@abstract func is_up_pressed() -> bool
@abstract func is_down_pressed() -> bool
@abstract func is_left_pressed() -> bool
@abstract func is_right_pressed() -> bool
@abstract func is_up_just_pressed() -> bool
@abstract func is_down_just_pressed() -> bool
@abstract func is_left_just_pressed() -> bool
@abstract func is_right_just_pressed() -> bool

@abstract func get_x_axis() -> float

@abstract func is_jump_pressed() -> bool
@abstract func is_jump_just_pressed() -> bool
@abstract func is_jump_just_released() -> bool

@abstract func is_attack_just_pressed() -> bool
@abstract func is_attack_just_released() -> bool

@abstract func is_special_just_pressed() -> bool
@abstract func is_special_just_released() -> bool

@abstract func is_accept_just_pressed() -> bool
