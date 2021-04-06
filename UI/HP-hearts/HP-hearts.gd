extends Control

var heart_empty := preload("res://assets/hp/frame_3.png")
var heart_half := preload("res://assets/hp/frame_2.png")
var heart_full := preload("res://assets/hp/frame_1.png")

var MAX_HP: int
var HP : int
var is_initilized := false

onready var hearts_container := $HBoxContainer
	
func initialize(hp):
	MAX_HP = hp
	HP = MAX_HP
	for i in range(MAX_HP / 2):
		var texture_rect = TextureRect.new()
		texture_rect.expand = true
		texture_rect.rect_min_size = Vector2(40, 40)
		texture_rect.size_flags_horizontal = SIZE_EXPAND_FILL
		texture_rect.size_flags_vertical = SIZE_EXPAND_FILL
		texture_rect.texture = heart_full
		hearts_container.add_child(texture_rect)
	is_initilized = true
	
func update_health(value):
	if not is_initilized:
		initialize(value)
	for i in hearts_container.get_child_count():
		var child = hearts_container.get_child(i)
		if value > i * 2 + 1:
			child.texture = heart_full
		elif value > i * 2:
			child.texture = heart_half
		else:
			child.texture = heart_empty
