@abstract
@icon("res://scenes/fighter/move.svg")
class_name Move extends Node2D

var fighter: Fighter

@export_custom(PROPERTY_HINT_NONE, "suffix:s") var cooldown := 0.3

@abstract
func run_move() -> void

func set_fighter(fighter: Fighter) -> void:
	self.fighter = fighter

func can_run_move() -> bool:
	return true
