extends Control

export var show_time_left = true
onready var time_left := $MarginContainer/HBoxContainer/TimeLeftContainer/HBoxContainer/TimeLeft
onready var dialog_root := $DialogRoot

# Called when the node enters the scene tree for the first time.
func _ready():
	if not show_time_left:
		$MarginContainer/HBoxContainer/TimeLeftContainer.hide()
		
func on_player_hp_change(hp):
	$MarginContainer/HBoxContainer/HPHearts.update_health(hp)

func show_dead_msg():
	$CenterContainer/Dead.visible = true

func on_time_left_change(seconds):
	time_left.text = format_time(seconds)

func format_time(seconds: int):
	var minutes = seconds / 60
	var last_sec = seconds - (minutes * 60)
	
	return "%s:%s" % [minutes, "0%s" % last_sec if last_sec < 10 else last_sec]


func set_dialog(dialog: Node):
	$DialogRoot.add_child(dialog)
