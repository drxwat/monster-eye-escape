extends "res://enemies/Enemy.gd"

export var DAMAGE = 1

var is_return_attack = false

onready var body_sprite = $Graphix/BodySprite

func _ready():
	pass # Replace with function body.

func chase(target):
	.chase(target)
	play_animation('run')

func move_to_point(point_gp):
	.move_to_point(point_gp)
	play_animation('run')

func idle():
	.idle()
	play_animation('idle')

func die():
	.die()
	$Graphix/Sword.hide()
	play_animation('death')

func attack(target):
	.attack(target)
	if not is_return_attack:
		$AnimationPlayer.play("attack")

func play_animation(anim):
	if body_sprite.animation != anim or not body_sprite.playing:
		body_sprite.play(anim)
	
func move_along_path(delta):
	.move_along_path(delta)
	play_animation('run')

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name != "attack":
		return
	
	if is_return_attack:
		is_return_attack = false
		return

	var victims = $AttackArea.get_overlapping_bodies()
	if not victims.empty() and victims[0] is RigidPlayer:
		var dir = global_position.direction_to(victims[0].global_position)
		victims[0].take_damage(DAMAGE, dir * 25)
	is_return_attack = true
	$AnimationPlayer.play_backwards("attack")
	
