extends Sprite2D

@export var animation_player: AnimationPlayer
@export var flip_via_scale: Array[Node2D]
@export var fall_frame := -1
@export var jump_frame := -1

@export_group("Physics")
@export var gravity := 1000.0
@export var jump_gravity := 700.0
@export var jump_velocity := 250.0

@onready var floor_pos := position.y
var velocity := 0.0

func _ready() -> void:
	if animation_player != null: animation_player.play("play")
	
	if flip_h:
		for node in flip_via_scale:
			node.scale.x *= -1

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
			
			if animation_player != null:
				#anim_player.stop()
				animation_player.play("play")
