@tool
# Having a class name is handy for picking the effect in the Inspector.
class_name RichTextBlinkTextEffect
extends RichTextEffect


# To use this effect:
# - Enable BBCode on a RichTextLabel.
# - Register this effect on the label.
# - Use [blink_text_effect param=2.0]hello[/blink_text_effect] in text.
var bbcode := "flash"


func _process_custom_fx(char_fx: CharFXTransform) -> bool:
	var color1: Color = char_fx.env.get("color1", Color("#e97a49"))
	var color2: Color = char_fx.env.get("color2", Color("#f7bf48"))
	var speed: float = char_fx.env.get("speed", 1.0)
	
	char_fx.color = color1 if fmod(char_fx.elapsed_time, speed) > speed / 2 else color2
	return true
