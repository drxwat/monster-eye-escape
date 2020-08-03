extends Sprite

signal pressed
var is_pressed = false
var is_released = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func on_action_pressed():
	is_pressed = true
	is_released = false
	emit_signal("pressed")

func _on_ActionButton_released():
	is_pressed = false
	is_released = true
