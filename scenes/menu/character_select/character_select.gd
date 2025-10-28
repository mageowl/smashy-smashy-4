extends Control

signal _p1_selected
signal _p2_selected

const ROSTER: Roster = preload("uid://c2jecj5wpkvkq")

var selector1_idx := 0
var selector2_idx := 0
var p1_selecting := false
var p2_selecting := false
var p1_preview: Sprite2D = null
var p2_preview: Sprite2D = null
@onready var selector1_target: Vector2 = $SelectorP1.position
@onready var selector2_target: Vector2 = $SelectorP2.position

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Game.update_input(Game.GameMode.LOCAL_1V1)
	
	for fighter: FighterConfig in ROSTER:
		var img := TextureRect.new()
		img.texture = fighter.texture
		img.set_meta(&"fighter", fighter)
		$Fighters.add_child(img)
	
	if ROSTER.fighters.size() < 8:
		for i in range(8 - ROSTER.fighters.size()):
			var img := NinePatchRect.new()
			img.texture = preload("uid://vi42848e4ctl")
			img.patch_margin_top = 4
			img.patch_margin_bottom = 4
			img.patch_margin_left = 4
			img.patch_margin_right = 4
			img.custom_minimum_size = Vector2(20, 20)
			$Fighters.add_child(img)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$SelectorP1.position = $SelectorP1.position.lerp(selector1_target, 18 * delta)
	$SelectorP2.position = $SelectorP2.position.lerp(selector2_target, 18 * delta)
	
	# TODO: convert selectors into scenes
	if Game.inputs[0].is_left_just_pressed():
		_move_p1(Vector2i(-1, 0))
	elif Game.inputs[0].is_right_just_pressed():
		_move_p1(Vector2i(1, 0))
	elif Game.inputs[0].is_up_just_pressed():
		_move_p1(Vector2i(0, -1))
	elif Game.inputs[0].is_down_just_pressed():
		_move_p1(Vector2i(0, 1))
	elif Game.inputs[0].is_accept_just_pressed():
		_select_p1()
	elif Game.inputs[1].is_left_just_pressed():
		_move_p2(Vector2i(-1, 0))
	elif Game.inputs[1].is_right_just_pressed():
		_move_p2(Vector2i(1, 0))
	elif Game.inputs[1].is_up_just_pressed():
		_move_p2(Vector2i(0, -1))
	elif Game.inputs[1].is_down_just_pressed():
		_move_p2(Vector2i(0, 1))
	elif Game.inputs[1].is_accept_just_pressed():
		_select_p2()
	elif $StartPrompt.visible and Input.is_action_just_pressed("start"):
		p1_selecting = true
		p2_selecting = true
		Effects.transition.to("res://scenes/world/world.tscn")

func _move_p1(direction: Vector2i) -> void:
	if $SelectorP1.visible:
		var new_idx: int = selector1_idx + direction.x + direction.y * $Fighters.columns
		if new_idx >= $Fighters.get_child_count() or new_idx < 0: return
		selector1_idx = new_idx
		selector1_target = $Fighters.get_child(new_idx).global_position - Vector2(5, 5)

func _move_p2(direction: Vector2i) -> void:
	if $SelectorP2.visible:
		var new_idx: int = selector2_idx + direction.x + direction.y * $Fighters.columns
		if new_idx >= $Fighters.get_child_count() or new_idx < 0: return
		selector2_idx = new_idx
		selector2_target = $Fighters.get_child(new_idx).global_position - Vector2(5, 5)

func _select_p1() -> void:
	if $SelectorP1.visible:
		var img: Control = $Fighters.get_child(selector1_idx)
		if img.has_meta(&"fighter"):
			$SelectorP1.hide()
			if p1_selecting: await _p1_selected
			
			var fighter: FighterConfig = img.get_meta(&"fighter")
			Game.player1_fighter = fighter
			
			$FighterP1/Name.text = "the " + fighter.name.to_lower()
			$FighterP1/Attack.text = fighter.name_attack
			$FighterP1/Special.text = fighter.name_special
			
			if fighter.preview_scene != null:
				p1_preview = fighter.preview_scene.instantiate()
				p1_preview.position = Vector2(56.5, 120)
				$FighterP1.add_child(p1_preview)
			
			p1_selecting = true
			var tween := create_tween()
			tween.tween_property($FighterP1, "position:x", 0, 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
			tween.parallel().tween_property($FighterP1/Background, "color", fighter.color, 0.1) \
				.set_custom_interpolator(floor) \
				.from(Color.WHITE)
			
			await tween.finished
			p1_selecting = false
			_p1_selected.emit()
			
			_check_ready()
	else:
		if p1_selecting: await _p1_selected
		$SelectorP1.show()
		
		Game.player1_fighter = null
		
		p1_selecting = true
		var tween := create_tween()
		tween.tween_property($FighterP1, "position:x", -113, 0.2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
		await tween.finished
		
		$FighterP1/Background.color = Color.WHITE
		if p1_preview != null:
			p1_preview.queue_free()
			p1_preview = null
		
		p1_selecting = false
		_p1_selected.emit()

func _select_p2() -> void:
	if $SelectorP2.visible:
		var img: Control = $Fighters.get_child(selector2_idx)
		if img.has_meta(&"fighter"):
			$SelectorP2.hide()
			if p2_selecting: await _p2_selected
			
			var fighter: FighterConfig = img.get_meta(&"fighter")
			Game.player2_fighter = fighter
			
			$FighterP2/Name.text = "the " + fighter.name.to_lower()
			$FighterP2/Attack.text = fighter.name_attack
			$FighterP2/Special.text = fighter.name_special
			
			if fighter.preview_scene != null:
				p2_preview = fighter.preview_scene.instantiate()
				p2_preview.position = Vector2(56.5, 120)
				p2_preview.flip_h = true
				$FighterP2.add_child(p2_preview)
			
			p2_selecting = true
			var tween := create_tween()
			tween.tween_property($FighterP2, "position:x", get_viewport_rect().size.x - 113, 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
			tween.parallel().tween_property($FighterP2/Background, "color", fighter.color, 0.2) \
				.set_custom_interpolator(floor) \
				.from(Color.WHITE)
			
			await tween.finished
			p2_selecting = false
			_p2_selected.emit()
			
			_check_ready()
	else:
		if p2_selecting: await _p2_selected
		$SelectorP2.show()
		
		Game.player2_fighter = null
		
		p2_selecting = true
		var tween := create_tween()
		tween.tween_property($FighterP2, "position:x", get_viewport_rect().size.x, 0.2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
		await tween.finished
		
		$FighterP2/Background.color = Color.WHITE
		if p2_preview != null:
			p2_preview.queue_free()
			p2_preview = null
		
		p2_selecting = false
		_p2_selected.emit()

func _check_ready() -> void:
	$StartPrompt.visible = not $SelectorP1.visible and not $SelectorP2.visible
