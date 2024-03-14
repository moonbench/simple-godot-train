extends Node

@onready var train : Train = get_parent()

func _process(delta: float) -> void:
	_update_throttle(delta)
	_update_brake(delta)

func _input(event: InputEvent) -> void:
	if event.is_pressed():
		if event.is_action_pressed("set_throttle_0"):
			train.throttle_percent = 0.0
		if event.is_action_pressed("set_throttle_10"):
			train.throttle_percent = 0.1
		if event.is_action_pressed("set_throttle_20"):
			train.throttle_percent = 0.2
		if event.is_action_pressed("set_throttle_30"):
			train.throttle_percent = 0.3
		if event.is_action_pressed("set_throttle_40"):
			train.throttle_percent = 0.4
		if event.is_action_pressed("set_throttle_50"):
			train.throttle_percent = 0.5
		if event.is_action_pressed("set_throttle_60"):
			train.throttle_percent = 0.6
		if event.is_action_pressed("set_throttle_70"):
			train.throttle_percent = 0.7
		if event.is_action_pressed("set_throttle_80"):
			train.throttle_percent = 0.8
		if event.is_action_pressed("set_throttle_90"):
			train.throttle_percent = 0.9
		if event.is_action_pressed("set_throttle_100"):
			train.throttle_percent = 1.0

# Set the "throttle lever" position
func _update_throttle(delta: float) -> void:
	if Input.is_action_pressed("speed_up"):
		train.throttle_percent = min(train.throttle_percent + train.throttle_movement_speed * delta, 1)
	elif Input.is_action_pressed("slow_down"):
		train.throttle_percent = max(train.throttle_percent - train.throttle_movement_speed * delta, -1)
	elif Input.is_action_pressed("cut_throttle"):
		train.throttle_percent = 0

# Set the percent of the total force with which the brake is being applied
func _update_brake(delta: float) -> void:
	if Input.is_action_pressed("brake"):
		train.brake_percent = clamp(train.brake_percent + train.brake_application_speed * delta, 0, 1)
	elif train.brake_percent > 0:
		train.brake_percent = clamp(train.brake_percent - train.brake_application_speed * delta, 0, 1)
