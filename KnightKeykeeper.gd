extends "res://enemies/knight/Knight.gd"

export var item_sceene: PackedScene

var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()

func die():
	.die()
	$Graphix/Item.hide()
	if not item_sceene:
		return
	var drop = item_sceene.instance()
	drop.position = global_position + Vector2(rng.randi_range(5, 10), rng.randi_range(5, 10))
	get_tree().get_current_scene().add_child(drop)
