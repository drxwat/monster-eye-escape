extends RigidBody2D

export var level_sceene: PackedScene

func _on_NextLevel_body_entered(body):
	if not level_sceene:
		return
	Global.goto_scene(level_sceene)
