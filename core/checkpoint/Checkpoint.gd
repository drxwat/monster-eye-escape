extends Area2D

const DIALOG_TERMINATE_SIGNAL = "on_terminate"

export var dialogic_timeline : String

var is_enabled = true
var player: RigidPlayer

signal on_enter

func set_enabled(value: bool):
	is_enabled = value
	$CollisionShape2D.disabled = !is_enabled

func enter_checkpoint(body: RigidPlayer):
	player = body
	player.disabled = true
	player.linear_velocity = Vector2.ZERO
	var new_dialog = Dialogic.start(dialogic_timeline)
	new_dialog.debug_mode = true
	new_dialog.connect("dialogic_signal", self, "terminate_checkpoint")
	emit_signal("on_enter", new_dialog)
	
func terminate_checkpoint(event_name):
	print("TERMINATE")
	if event_name == DIALOG_TERMINATE_SIGNAL:
		player.disabled = false
		set_enabled(false)
