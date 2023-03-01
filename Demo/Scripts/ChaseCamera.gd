extends Camera2D

export var max_zoom = 0.1
export var min_zoom = 1.5
export var zoom_rate = 0.25

var desired_zoom = zoom.x

func _process(delta):
	if zoom.x != desired_zoom:
		zoom.x = clamp(lerp(zoom.x, desired_zoom, delta), max_zoom, min_zoom)
		zoom.y = zoom.x

func _input(event):
	if event.is_action_pressed("zoom_in"):
		desired_zoom = clamp(desired_zoom * (1-zoom_rate), max_zoom, min_zoom)
	elif event.is_action_pressed("zoom_out"):
		desired_zoom = clamp(desired_zoom * (1+zoom_rate), max_zoom, min_zoom)
