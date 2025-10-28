extends Node

const IGNORED_NAMES: Array[String] = [
	"keychron",
	"keyboard",
	"mouse"
]

const NINTENDO_NAMES: Array[String] = [
	"Pro Controller",
	"Joycon",
	"8bitdo"
]

enum GameMode {
	LOCAL_1V1
}

var player1_score := 0
var player2_score := 0
var player1_fighter: FighterConfig
var player2_fighter: FighterConfig
var inputs: Array[GenericInput]
var _players: Node2D

func set_players(parent: Node2D) -> void:
	_players = parent

func get_players() -> Array[Node]:
	return _players.get_children()

func reset() -> void:
	player1_score = 0
	player2_score = 0

func update_input(game_mode: GameMode) -> void:
	match game_mode:
		GameMode.LOCAL_1V1:
			var controllers := Input.get_connected_joypads()
			var is_nintendo: Array[bool] = []
			
			for i in range(controllers.size() - 1, -1, -1):
				if not _valid_controller(controllers[i]):
					controllers.remove_at(i)
				
				var n := false
				for word in NINTENDO_NAMES:
					if Input.get_joy_name(i).contains(word):
						n = true
						print_debug("Detected joypad " + str(i) + " to have switched A and B buttons.")
						break
				is_nintendo.push_back(n)
			
			if controllers.size() >= 2:
				inputs = [ControllerInput.new(controllers[0], is_nintendo[0]), ControllerInput.new(controllers[1], is_nintendo[1])]
			elif controllers.size() == 1:
				inputs = [ControllerInput.new(controllers[0], is_nintendo[0]), ActionPrefixInput.new("solo")]
			else:
				inputs = [ActionPrefixInput.new("p1"), ActionPrefixInput.new("p2")]
		_:
			assert(false, "Unreachable")

func _valid_controller(device_id: int) -> bool:
	for word in IGNORED_NAMES:
		var joy_name := Input.get_joy_name(device_id)
		if joy_name.containsn(word):
			print_debug("Skipping device '" + joy_name + "' at " + str(device_id) + ", because of word '" + word + "'")
			return false
	return true

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.keycode == KEY_1:
			if event.is_pressed(): Engine.time_scale = 0.1
			else: Engine.time_scale = 1
