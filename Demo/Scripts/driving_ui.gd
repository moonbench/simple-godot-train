extends CanvasLayer

@onready var controls_box := %ControlsPanel
@onready var info_box := %InfoBox
@onready var camera_control_box := %ControlsPanel

func _ready():
	%ControlsButton.toggled.emit(%ControlsButton.button_pressed)
	%InfoButton.toggled.emit(%InfoButton.button_pressed)

func update_train_info(info):
	info_box.update_info(info)

func _on_info_button_toggled(toggled_on: bool) -> void:
	info_box.visible = toggled_on

func _on_controls_button_toggled(toggled_on: bool) -> void:
	controls_box.visible = toggled_on

func _on_button_pressed() -> void:
	Game.switch_to_scene("res://Demo/Scenes/Game.tscn")

func _on_exit_pressed() -> void:
	Game.exit()
