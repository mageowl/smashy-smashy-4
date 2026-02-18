class_name Fighter extends CharacterBody2D

signal died
signal hit_by_force

@export var color: Color
@export_node_path("AnimationPlayer") var animation_player: NodePath

@export_group("Physics")
@export var midair_jumps := 0
@export var gravity := 1000.0
@export var jump_gravity := 700.0
@export var fast_fall_gravity := 2000.0
@export var jump_velocity := 250.0

@export var coyote_time := 6
@export var jump_hold := 8
@export var move_hold := 8

@export var speed := 150.0
@export var acceleration := 30.0
@export var air_acceleration := 18.0
@export var friction := 6.0
@export var air_friction := 3.0
@export var knockback_friction := 2.4
@export var knockback_threshold := 2.0

@export_group("Moveset", "moveset_")
@export_node_path("Move") var moveset_attack: NodePath
@export_node_path("Move") var moveset_special: NodePath

@onready var attack: Move = get_node(moveset_attack)
@onready var special: Move = get_node(moveset_special)
@onready var animation: AnimationPlayer = get_node(animation_player)
@onready var idle_animation := &"idle" if animation.has_animation("idle") else &"RESET"

@onready var midair_jumps_remaining := midair_jumps
var is_player_2: bool = false
var falling := 0
var jump_input := 0
var move_input := 0
var cooldown := 0.0
var max_cooldown := 0.0
var playing_move_anim := false
var velocity_scale := 1.0
var gravity_scale := 1.0
var attack_scale := 1.0
var start_input_lock := true
var cancel_force := false
var grabbed := false
var lock_direction := false
var input: GenericInput

func _ready() -> void:
	($CooldownBar.texture_progress as GradientTexture2D).gradient.colors[0] = color
	$Marker.modulate = color
	
	attack.set_fighter(self)
	special.set_fighter(self)
	
	if is_player_2:
		$Sprite.flip_h = true

func _gravity(delta: float) -> void:
	if not is_on_floor():
		var g := gravity
		if input.is_down_pressed():
			g = fast_fall_gravity
		elif velocity.y < 0:
			g = jump_gravity
		
		velocity.y += g * delta * velocity_scale * gravity_scale
		
		if not playing_move_anim:
			if velocity.y < 0: animation.play("jump")
			else: animation.play("fall")
	else:
		if falling < coyote_time - 1: Effects.screen_shake(3)
		falling = coyote_time
		midair_jumps_remaining = midair_jumps
		start_input_lock = false

func _jump() -> void:
	if jump_input > 0: jump_input -= 1
	if input.is_jump_pressed():
		jump_input = jump_hold
	
	if falling > 0:
		falling -= 1
		
		if jump_input > 0:
			velocity.y = -jump_velocity * velocity_scale
			falling = 0
	elif input.is_jump_just_pressed() and midair_jumps_remaining > 0:
		velocity.y = -jump_velocity * velocity_scale
		falling = 0
		midair_jumps_remaining -= 1

func _move(delta: float) -> void:
	if abs(velocity.x) > speed * knockback_threshold:
		velocity.x = move_toward(velocity.x, 0, speed * knockback_threshold * delta * velocity_scale)
	else:
		var direction := input.get_x_axis()
		if direction:
			velocity.x = move_toward(velocity.x, direction * speed * velocity_scale, speed * if_air(air_acceleration, acceleration) * delta * velocity_scale)
			if not lock_direction: $Sprite.flip_h = direction < 0
			if not playing_move_anim and is_on_floor(): animation.play("run")
		else:
			velocity.x = move_toward(velocity.x, 0, speed * if_air(air_friction, friction) * delta * velocity_scale)
			if not playing_move_anim and is_on_floor(): animation.play(idle_animation)

func _attack(delta: float) -> void:
	if input.is_attack_just_pressed():
		move_input = move_hold
	elif input.is_special_just_pressed():
		move_input = -move_hold
	elif move_input != 0:
		move_input = int(move_toward(move_input, 0, 1))
	
	if cooldown > 0:
		cooldown = move_toward(cooldown, 0.0, delta)
		$CooldownBar.value = int(cooldown / max_cooldown * 10)
	elif move_input > 0:
		run_move(attack, "attack")
		move_input = 0
	elif move_input < 0:
		run_move(special, "special")
		move_input = 0


func _physics_process(delta: float) -> void:
	if not grabbed:
		_gravity(delta)
		_jump()
		_move(delta)
	if not start_input_lock:
		_attack(delta)
	
	## Off-screen marker
	if not $VisibleOnScreenNotifier2D.is_on_screen():
		var rect := (get_viewport_rect() * get_canvas_transform()).grow(-10)
		$Marker.position = position.clamp(rect.position, rect.end)
		$Marker.rotation = TAU / 4 + $Marker.position.angle_to_point(position)
		if cooldown > 0: $Marker/CooldownBar.value = cooldown / max_cooldown * 8
		else: $Marker/CooldownBar.value = 0
	
	## Death
	if position.y > get_viewport_rect().size.y:
		died.emit()
		queue_free()
	
	if not grabbed: move_and_slide()

func if_air(air: float, ground: float) -> float:
	return ground if is_on_floor() else air

func get_flip_sign() -> int:
	return -1 if $Sprite.flip_h else 1

func get_flip() -> bool:
	return $Sprite.flip_h

func get_input_direction() -> float:
	var direction := input.get_x_axis()
	if abs(direction) < 0.1: direction = get_flip_sign()
	return direction

func set_cooldown(value: float) -> void:
	cooldown = value
	max_cooldown = value
	if value == 0: $CooldownBar.value = 0

func play_move_anim(anim: StringName) -> void:
	if not animation.has_animation(anim): return
	animation.play(anim)
	playing_move_anim = true
	await animation.animation_finished
	playing_move_anim = false

func apply_force(force: Vector2) -> void:
	hit_by_force.emit()
	if not cancel_force: velocity += force * velocity_scale * attack_scale
	else: cancel_force = false

func apply_override_force(force: Vector2) -> void:
	hit_by_force.emit()
	if not cancel_force: velocity = force * velocity_scale
	else: cancel_force = false

func set_velocity_scale(amount: float) -> void:
	if amount < velocity_scale: velocity *= amount / velocity_scale
	velocity_scale = amount

func run_move(move: Move, anim: StringName) -> void:
	if move.can_run_move():
		move.run_move()
		set_cooldown(move.cooldown)
		play_move_anim(anim)
