extends RigidBody2D
class_name PickablObject

var rng = RandomNumberGenerator.new()

export(Enums.DROP) var drop_type = Enums.DROP.NONE
export (PackedScene) var picked_item_sceene

func get_picket_item_sceene():
	return picked_item_sceene
	
func get_normal_item_path():
	return filename

func drop_item():
	if drop_type == Enums.DROP.NONE:
		return
	var drop_scene = Global.DROP_SCENES[drop_type]
	var drop = drop_scene.instance()
	drop.position = global_position + Vector2(rng.randi_range(5, 10), rng.randi_range(5, 10))
	get_tree().get_current_scene().add_child(drop)

func on_destroy():
	drop_item()
