extends Node

signal option_changed(name: StringName)

const FILE_PATH = "user://options.json"
const OPTIONS: Array[StringName] = [
	&"screen_shake_multiplier",
	&"brightness",
	&"sfx_volume",
	&"disable_freeze_frame",
	&"disable_background_motion",
	&"high_contrast_bg",
]

var screen_shake_multiplier := 1.0
@export var brightness := 1.0
@export var sfx_volume := 1.0
@export var disable_freeze_frame := false
@export var disable_background_motion := false
@export var high_contrast_bg := false

@onready var sfx_channel := AudioServer.get_bus_index("SFX")

func _enter_tree() -> void:
	var file := FileAccess.open(FILE_PATH, FileAccess.READ)
	
	if file != null:
		var json: Dictionary = JSON.parse_string(file.get_as_text())
		
		for k in OPTIONS:
			if json.has(k):
				set_option(k, json[k])

func _exit_tree() -> void:
	var file := FileAccess.open(FILE_PATH, FileAccess.WRITE)
	var json := {}
	
	for k in OPTIONS:
		json[k] = get(k)
	
	file.store_string(JSON.stringify(json))
	file.close()

func set_option(property: StringName, value: Variant) -> void:
	set(property, value)
	
	if property == &"sfx_volume": AudioServer.set_bus_volume_linear(sfx_channel, float(value))
	
	if OPTIONS.has(property): option_changed.emit(property)
