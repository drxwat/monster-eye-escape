extends PickablObject
class_name Bucket

export var BASE_DAMAGE = 1
var already : bool

var FORCE_DEVIDER = 40
var MAX_HP := 2
var now_HP = MAX_HP

func _ready():
	pass # Replace with function body.

func blowup():
	$AnimatedSprite.play("blowup")
	yield($AnimatedSprite, "animation_finished")
	on_destroy()
	queue_free()
	
func take_partial_damage():
	#if !already:
		#print(now_HP)
	now_HP = now_HP - 1
		#print(now_HP)
		#if now_HP > 0:
		#	$AnimatedSprite.frame = MAX_HP - HP
	if now_HP < 0:
		blowup()

func _on_Area2D_body_entered(body):
	if body is Enemy:
		var force = linear_velocity.length()
		var damage = BASE_DAMAGE * ceil((force / FORCE_DEVIDER))
		if damage > 1:
			body.take_partial_damage(damage - 1)
			body.push(position.direction_to(body.position))
		take_partial_damage()
	#	already = true
