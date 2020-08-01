class_name PickablObject
extends RigidBody2D

export (PackedScene) var picked_item_sceene

func get_picket_item_sceene():
	return picked_item_sceene
	
func get_normal_item_path():
	return filename
