class_name FighterConfig extends Resource

@export var texture: AtlasTexture
@export var name: String
@export var color: Color
@export var preview_scene: PackedScene
@export var scene: PackedScene

@export_group("Moveset", "name_")
@export var name_attack: String
@export var name_special: String
