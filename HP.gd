extends Control

var HP = 4

var BAR_UNIT = 45

func _ready():
	pass

func setHP(value):
	HP = value
	_drawBAR()

func _drawBAR():
	$ColorRect.rect_size.x = HP * BAR_UNIT
