extends Node2D

signal time_left_change

export var attacker1: NodePath
export var attacker2: NodePath
export var time_left := 90

func _ready():
	$atttack_door.play()
	emit_signal("time_left_change", time_left)

func _process(delta):
	if time_left > 0:
		get_node(attacker1).attack(null)
		get_node(attacker2).attack(null)

func _on_atttack_door_finished():
	if time_left > 0:
		$atttack_door.play()

func _on_Timer_timeout():
	if time_left <= 0:
		$Timer.stop()
		start_hunt()
		$Timer.start(5)
		return
	time_left -= 1
	emit_signal("time_left_change", time_left)

func start_hunt():
	if $HUNT_GATE:
		$HUNT_GATE.queue_free()
	var i = 0
	for chaser in $chasers.get_children():
		chaser.disabled = false
		var path = Global.get_nav_path(chaser.position, $RigidPlayer.position)
		chaser.set_path(path)

func _on_AudioStreamPlayer_finished():
	$AudioStreamPlayer.play()

func _on_NextLevel_body_entered(body):
	Global.goto_outro()
