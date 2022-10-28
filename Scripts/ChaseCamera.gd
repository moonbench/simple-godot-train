extends Camera2D

export var max_zoom = 0.1
export var min_zoom = 1.5
export var zoom_rate = 0.1

func _input(event):
	if event.is_action_pressed("zoom_in"):
		zoom.x = clamp(zoom.x * (1-zoom_rate), max_zoom, min_zoom)
		zoom.y = zoom.x
	elif event.is_action_pressed("zoom_out"):
		zoom.x = clamp(zoom.x * (1+zoom_rate), max_zoom, min_zoom)
		zoom.y = zoom.x
