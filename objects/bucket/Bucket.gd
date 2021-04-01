extends PickablObject

export var BASE_DAMAGE = 1

var FORCE_DEVIDER = 40

func _ready():
	pass # Replace with function body.

func blowup():
	$AnimatedSprite.play()
	yield($AnimatedSprite, "animation_finished")
	queue_free()

func _on_Area2D_body_entered(body):
	if body is Enemy:
		var force = linear_velocity.length()
		var damage = BASE_DAMAGE * ceil((force / FORCE_DEVIDER))
		if damage > 1:
			body.take_damage(damage - 1)
			body.push(position.direction_to(body.position))
