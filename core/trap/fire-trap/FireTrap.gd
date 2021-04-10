extends Area2D

var in_progress := false
var damage := 2

onready var sprite := $TrapSprite

func warm_up(body: Node):
	if in_progress:
		return
	in_progress = true
	sprite.play("warm_up")
	yield(sprite, "animation_finished")
	fire()
	
func fire():
	sprite.play("fire")
	var victims = get_overlapping_bodies()
	for victim in victims:
		if victim.has_method('take_damage'):
			victim.take_damage(damage)
	yield(sprite, "animation_finished")
	calm_down()

func calm_down():
	sprite.play("calm_down")
	in_progress = false
