@icon("InputEventJoypadMotion")
class_name ControllerInput extends ActionPrefixInput

static var created_input_maps: Array[int] = []

var device_id: int
var is_nintendo: bool

func _init(device_id: int, is_nintendo: bool) -> void:
	super("g" + str(device_id))
	self.device_id = device_id
	self.is_nintendo = is_nintendo
	
	print_debug("Controller " + Input.get_joy_name(device_id) + " at " + str(device_id))
	
	if created_input_maps.has(device_id):
		print_debug("Input map id " + str(device_id) + " already generated.")
	else:
		created_input_maps.push_back(device_id)
		
		_add_dpad_or_stick("up", JoyButton.JOY_BUTTON_DPAD_UP, JoyAxis.JOY_AXIS_LEFT_Y, -1)
		_add_dpad_or_stick("down", JoyButton.JOY_BUTTON_DPAD_DOWN, JoyAxis.JOY_AXIS_LEFT_Y, 1)
		_add_dpad_or_stick("left", JoyButton.JOY_BUTTON_DPAD_LEFT, JoyAxis.JOY_AXIS_LEFT_X, -1)
		_add_dpad_or_stick("right", JoyButton.JOY_BUTTON_DPAD_RIGHT, JoyAxis.JOY_AXIS_LEFT_X, 1)
		
		_add_button("jump", JoyButton.JOY_BUTTON_A)
		_add_dpad_or_stick("attack", JoyButton.JOY_BUTTON_X, JoyAxis.JOY_AXIS_TRIGGER_LEFT, 1)
		_add_dpad_or_stick("special", JoyButton.JOY_BUTTON_Y, JoyAxis.JOY_AXIS_TRIGGER_RIGHT, 1)
		
		if is_nintendo:
			_add_button("accept", JOY_BUTTON_B)
		else:
			_add_button("accept", JOY_BUTTON_A)

func _add_button(name: String, ...buttons: Array) -> StringName:
	var id := StringName(prefix + "_" + name)
	InputMap.add_action(id, 0.5)
	
	for index: JoyButton in buttons:
		var event := InputEventJoypadButton.new()
		event.button_index = index
		event.device = device_id
		InputMap.action_add_event(id, event)
	
	return id

func _add_dpad_or_stick(name: String, dpad: JoyButton, axis: JoyAxis, direction: float) -> StringName:
	var id := _add_button(name, dpad)
	
	var event := InputEventJoypadMotion.new()
	event.axis = axis
	event.axis_value = direction
	event.device = device_id
	InputMap.action_add_event(id, event)
	
	return id
