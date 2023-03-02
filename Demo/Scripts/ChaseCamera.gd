extends Camera2D

export var max_zoom = 0.1
export var min_zoom = 1.5
export var zoom_step = 0.25
export var zoom_speed = 3

var desired_zoom = zoom.x

func _process(delta):
	if zoom.x != desired_zoom:
		zoom.x = clamp(lerp(zoom.x, desired_zoom, delta * zoom_speed), max_zoom, min_zoom)
		zoom.y = zoom.x

func _input(event):
	if event.is_action_pressed("zoom_in") || event.is_action_pressed("zoom_out"):
		_update_desired_zoom()
	elif Input.is_action_pressed("pan") && event is InputEventMouseMotion:
		_update_pan(event)
		
func _update_desired_zoom():
	if Input.get_axis("zoom_in", "zoom_out") > 0:
		desired_zoom = clamp(desired_zoom * (1 + zoom_step), max_zoom, min_zoom)
	else:
		desired_zoom = clamp(desired_zoom * (1 - zoom_step), max_zoom, min_zoom)

func _update_pan(event):
	offset -= event.relative.rotated(global_rotation) * zoom
	offset.x = clamp(offset.x, -1000, 1000)
	offset.y = clamp(offset.y, -750, 750)
