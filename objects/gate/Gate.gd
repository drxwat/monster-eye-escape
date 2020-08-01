extends RigidBody2D

signal on_open
signal on_close

export var is_opened = false

func _ready():
	if is_opened:
		$AnimatedSprite.animation = "close"
		$CollisionShape2D.disabled = true
	else:
		$AnimatedSprite.animation = "open"
		$CollisionShape2D.disabled = false

func open():
	$AnimatedSprite.play("open")
	$AudioStreamPlayer2D.play()
	
func close():
	$AnimatedSprite.play("close")
	$AudioStreamPlayer2D.play()
	
func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation == "open":
		is_opened = true
		$CollisionShape2D.disabled = true
		emit_signal("on_open")
	elif $AnimatedSprite.animation == "close":
		is_opened = false
		$CollisionShape2D.disabled = false
		emit_signal("on_close")

func _on_Gate_body_entered(body):
	if body is Key:
		body.queue_free()
		open()
