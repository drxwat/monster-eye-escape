extends Sprite

onready var joystick_button = get_node("JoystickButton")

func get_direction():
	return joystick_button.get_value()
