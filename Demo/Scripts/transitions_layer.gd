extends CanvasLayer

@onready var node = $Node2D
@onready var rect = $Node2D/ColorRect

func swipe_on():
	node.position = Vector2(-200, -64)
	rect.size = Vector2(1, 1000)
	
	var tween = create_tween()
	tween.tween_property(rect, "size", Vector2(2000, 1000), 0.6)
	tween.set_ease(Tween.EASE_OUT)

func swipe_off():
	node.position = Vector2(-100, -64)
	rect.size = Vector2(2000, 1000)
	
	var tween = create_tween()
	tween.tween_property(node, "position", Vector2(2000, -64), 0.8)
	tween.set_ease(Tween.EASE_IN)
