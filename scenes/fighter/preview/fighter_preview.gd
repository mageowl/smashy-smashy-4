extends Sprite2D

@export_node_path("AnimationPlayer") var animation_player: NodePath
@export var fall_frame := -1
@export var jump_frame := -1

@export_group("Physics")
@export var gravity := 1000.0
@export var jump_gravity := 700.0
@export var jump_velocity := 250.0

@onready var floor_pos := position.y
var velocity := 0.0
@onready var anim_player: AnimationPlayer = get_node_or_null(animation_player)

func _ready() -> void:
	if anim_player != null: anim_player.play("play")

func jump() -> void:
	velocity = -jump_velocity

func slam() -> void:
	velocity = 0
	position.y = floor_pos


func _process(delta: float) -> void:
	if velocity != 0 or position.y != floor_pos:
		velocity += (jump_gravity if velocity < 0 else gravity) * delta
		position.y += velocity * delta
		
		if velocity > 0 and fall_frame >= 0:
			frame = fall_frame
		elif velocity < 0 and jump_frame >= 0:
			frame = jump_frame
		
		if position.y >= floor_pos:
			position.y = floor_pos
			velocity = 0
			
			if anim_player != null:
				anim_player.stop()
				anim_player.play("play")
