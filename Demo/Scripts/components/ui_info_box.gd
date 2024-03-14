extends PanelContainer

@onready var throttle_label = %Throttle
@onready var force_label = %Force
@onready var brake_label = %Brake
@onready var velocity_label = %Velocity
@onready var mass_label = %Mass
@onready var friction_label = %Friction
@onready var drag_label = %Drag
@onready var max_velocity_label = %MaxVelocity
@onready var accel_label = %Acceleration
@onready var resist_label = %Resist

func update_info(info):
	throttle_label.text = "%0.1f%%" % (info["throttle"]*100)
	brake_label.text = "%0.1f%%" % (info["brake"]*100)
	force_label.text = "%d/%d (%0.1f%%)" % [round(info["force_applied"]), info["force_max"], (info["force_applied"]/info["force_max"])*100]
	accel_label.text = "%0.2f" % info["acceleration"]
	velocity_label.text = "%0.2f" % (0 if abs(info["velocity"]) < 0.1 else info["velocity"])
	max_velocity_label.text = "%0.2f" % info["max_velocity"]
	mass_label.text = "%0.2f" % info["total_mass"]
	friction_label.text = "%0.2f" % info["friction"]
	drag_label.text = "%0.2f" % info["drag"]
	resist_label.text = "%0.1f" % (info["drag"] + info["friction"])
