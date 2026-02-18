extends Node2D

var finishing := false
var p2_dead := false
var p1_dead := false

func _ready() -> void:
	Effects.set_camera($Camera2D)
	Game.set_players($Fighters)
	
	_create_fighter(false)
	_create_fighter(true)
	
	%Player1Score.text = str(Game.player1_score)
	%Player2Score.text = str(Game.player2_score)

func _create_fighter(is_p2: bool) -> void:
	var fighter: Fighter = (Game.player2_fighter if is_p2 else Game.player1_fighter).scene.instantiate()
	
	fighter.is_player_2 = is_p2
	fighter.position = Vector2(get_viewport_rect().size.x - 100.0 if is_p2 else 100.0, 10)
	fighter.input = Game.inputs[1 if is_p2 else 0]
	
	fighter.died.connect(func() -> void:
		if is_p2: p2_dead = true
		else: p1_dead = true
		_on_fighter_died(fighter))
	
	$Fighters.add_child(fighter)
	
	if is_p2: $%Player2Score.label_settings.font_color = fighter.color
	else: $%Player1Score.label_settings.font_color = fighter.color

func _on_fighter_died(fighter: Fighter) -> void:
	Effects.screen_shake(15)
	
	var pos := fighter.position.clamp(Vector2(-100, -100), get_viewport_rect().size + Vector2(100, 0))
	pos.y += 10
	
	$KillFX.position = pos
	$KillFX.rotation = PI / 2 + fighter.position.angle_to_point(get_viewport_rect().size / 2)
	$KillFX.emitting = true
	
	$KillLine.points[1] = pos
	
	var tween := create_tween()
	tween.tween_property($KillLine, "width", 20, 0.1).set_ease(Tween.EASE_OUT)
	tween.tween_property($KillLine, "width", 0, 0.3).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUART)
	
	if finishing: return
	finishing = true
	
	await get_tree().create_timer(1).timeout
	
	if not p1_dead and p2_dead: Game.player1_score += 1
	if p1_dead and not p2_dead: Game.player2_score += 1
	
	await Effects.transition.anim_in()
	get_tree().reload_current_scene()
	Effects.transition.anim_out()

func _process(_delta: float) -> void:
	var avg_pos := Vector2.ZERO
	for node: Node2D in $Fighters.get_children():
		avg_pos += node.position.clamp(Vector2.ZERO, get_viewport_rect().size)
	avg_pos /= max(1, $Fighters.get_child_count())
	
	var center := get_viewport_rect().size / 2
	$Camera2D.position.x = center.x + (avg_pos.x - center.x) / 12
