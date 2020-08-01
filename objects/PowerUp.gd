class_name PowerUp
extends KinematicBody2D

export var pick_up_sfx: AudioStream

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func get_pick_up_sfx():
	return pick_up_sfx 
