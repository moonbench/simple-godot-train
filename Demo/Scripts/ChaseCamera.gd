extends Camera2D

@export var max_zoom := 0.1
@export var min_zoom := 1.25
@export var zoom_step := 0.1
@export var zoom_speed := 2.0

var desired_zoom = zoom.x

func _process(delta):
	if zoom.x != desired_zoom:
		zoom.x = clamp(
			lerp(zoom.x, desired_zoom, delta * zoom_speed),
			max_zoom,
			min_zoom
		)
		zoom.y = zoom.x

func _input(event):
	if event.is_action_pressed("zoom_in") || event.is_action_pressed("zoom_out"):
		_update_desired_zoom()
	elif Input.is_action_pressed("pan") && event is InputEventMouseMotion:
		_update_pan(event)
		
func _update_desired_zoom():
	if Input.get_axis("zoom_in", "zoom_out") > 0:
		desired_zoom *= 1 + zoom_step
		desired_zoom = clamp(desired_zoom, max_zoom, min_zoom)
	else:
		desired_zoom *= 1 - zoom_step
		desired_zoom = clamp(desired_zoom, max_zoom, min_zoom)

func _update_pan(event):
	offset -= event.relative.rotated(global_rotation)
	offset = clamp(offset, Vector2(-1000, -750), Vector2(1000, 750))
