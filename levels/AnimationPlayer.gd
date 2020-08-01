extends AnimationPlayer

export var enemies: NodePath
export var gate: NodePath

export var knightAtk1: NodePath
export var knightAtk2: NodePath
export var knightLead: NodePath
export var door_cut: AudioStream
export var screem: AudioStream
export var first_level: PackedScene

var knights

var attack_door = false

# Called when the node enters the scene tree for the first time.
func _ready():
	play("first")
	knights = get_node(enemies).get_children()
	for k in knights:
		if k.has_method("play_animation"):
			k.play_animation("run")
	play("first")

func _process(delta):
	if attack_door:
		get_node(knightAtk1).attack(null)
		get_node(knightAtk2).attack(null)

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "first":
		get_node(gate).close()
		play("second")
	if anim_name == "second":
		for k in knights:
			if k.has_method("play_animation"):
				k.play_animation("idle")
		$AudioStreamPlayer.stream = screem
		$AudioStreamPlayer.play()
		play("third")
	if anim_name == "third":
		get_node(knightAtk1).play_animation("run")
		get_node(knightAtk2).play_animation("run")
		get_node(knightLead).play_animation("run")
		play("forth")
	if anim_name == "forth":
		get_node(knightAtk1).play_animation("idle")
		get_node(knightAtk2).play_animation("idle")
		get_node(knightLead).play_animation("idle")
		attack_door = true
		$AudioStreamPlayer.stream = door_cut
		$AudioStreamPlayer.play()
		play("fifth")
	if anim_name == "fifth":
		Global.goto_scene(first_level)

func _on_AudioStreamPlayer_finished():
	if $AudioStreamPlayer.stream == screem:
		return
	$AudioStreamPlayer.play()
