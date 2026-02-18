class_name TransitionRect extends CanvasLayer

const TEXTURES = [
	preload("uid://vl8jryusp4f4"),
	preload("uid://b1xga2jc7t00b"),
	preload("uid://dm18k7fyvh5fa"),
	preload("uid://bnlbl5spv70hw"),
	preload("uid://crand0kxv4uyl"),
	preload("uid://cq612b0l3ox00"),
	preload("uid://c1vku43sof8iy"),
	preload("uid://dqfchfwhwfwex")
]

var texture_idx := randi_range(0, TEXTURES.size() - 1)
var history: Array[String] = []

func _ready() -> void:
	$TextureRect.texture = TEXTURES[texture_idx]
	anim_out()

func anim_in() -> void:
	if $AnimationPlayer.current_animation != "in":
		texture_idx += randi_range(1, 3)
		texture_idx %= TEXTURES.size()
		$TextureRect.texture = TEXTURES[texture_idx]
	
	$AnimationPlayer.play("in")
	await $AnimationPlayer.animation_finished

func anim_out() -> void:
	$AnimationPlayer.play("out")
	await $AnimationPlayer.animation_finished

func go_back() -> void:
	await anim_in()
	get_tree().change_scene_to_file(history.pop_back())
	await get_tree().scene_changed
	await anim_out()

func to(path: String) -> void:
	await anim_in()
	history.push_back(get_tree().current_scene.scene_file_path)
	get_tree().change_scene_to_file(path)
	await get_tree().scene_changed
	await anim_out()

func to_packed(scene: PackedScene) -> void:
	if get_tree().current_scene == null: return
	await anim_in()
	history.push_back(get_tree().current_scene.scene_file_path)
	get_tree().change_scene_to_packed(scene)
	await get_tree().scene_changed
	await anim_out()
