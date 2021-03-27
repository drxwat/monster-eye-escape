extends RigidBody2D

export var next_level : PackedScene

func go_to_the_next_level(body: Node):
	if next_level and body is RigidPlayer:
		Global.goto_scene(next_level)
