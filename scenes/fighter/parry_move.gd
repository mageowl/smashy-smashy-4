class_name ParryMove extends Move

@export_custom(PROPERTY_HINT_NONE, "suffix:s") var parry_window := 0.2
@export_node_path("Move") var trigger: NodePath

@onready var trigger_move: Move = get_node(trigger)

var _time := 0.0
var _did_parry := false

func set_fighter(new: Fighter) -> void:
	super(new)
	new.hit_by_force.connect(_on_hit_by_force)
	trigger_move.set_fighter(new)

func _process(delta: float) -> void:
	if _time > 0:
		_time -= delta
		

func run_move() -> void:
	_time = parry_window
	_did_parry = false

func _on_hit_by_force() -> void:
	if _time > 0:
		fighter.cancel_force = true
		if not _did_parry:
			_did_parry = true
			_delay_trigger()

func _delay_trigger() -> void:
	await get_tree().create_timer(0.1, false, false, true).timeout
	fighter.run_move(trigger_move, "parry_trigger")
