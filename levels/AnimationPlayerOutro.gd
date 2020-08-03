extends AnimationPlayer

export var enemies: NodePath
export var start_screen: PackedScene

var knights

func _ready():
	knights = get_node(enemies).get_children()
	for k in knights:
		if k.has_method("play_animation"):
			k.play_animation("run")
	play("first")

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "first":
		for k in knights:
			if k.has_method("play_animation"):
				k.play_animation("idle")
		play("second")
	if anim_name == "second":
		Global.is_game_started = false
		Global.goto_scene(start_screen)
