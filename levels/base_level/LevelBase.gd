extends Node2D

onready var checkpoints_container := $Checkpoints

# Called when the node enters the scene tree for the first time.
func _ready():
	subscribe_to_checkpoints()
	
func subscribe_to_checkpoints():
	var checkpoints = checkpoints_container.get_children()
	for checkpoint in checkpoints:
		checkpoint.connect("on_enter", self, "show_dialog")
		
func show_dialog(dialog: Node):
	$CanvasLayer/GUI.set_dialog(dialog)
