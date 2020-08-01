class_name TitleScreen
extends Control

export var is_start_screen = true

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.title_screen = self
	if not is_start_screen:
		$Menu/CenterRow/Buttons/NewGame/Label.text = "Continue"

func _on_NewGame_pressed():
	if is_start_screen:
		Global.start_new_game()
	else:
		Global.toggle_pause()

func _on_Exit_pressed():
	Global.exit_game()
