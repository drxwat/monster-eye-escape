extends PickablObject
class_name Bomb

export var DAMAGE = 3
export var BLOW_SPEED = 25

onready var sprite = $AnimatedSprite
var is_blowed = false

func _ready():
	sprite.play('burn')

func blowup():
	if is_blowed:
		return
	is_blowed = true
	$AudioStreamPlayer2D.play()
	var victims = $ExplosionArea.get_overlapping_bodies()
	for victim in victims:
		var victim_ref = weakref(victim)
		if !victim_ref.get_ref():
			return
		if victim.has_method('take_damage'):
			victim.take_damage(DAMAGE)
		if victim.has_method('push'):
			victim.push(global_position.direction_to(victim.global_position).normalized())
		if victim.has_method("blowup"):
			yield(get_tree().create_timer(0.03), "timeout")
			if victim_ref.get_ref():
				victim_ref.get_ref().blowup()

	sleeping = true
	if sprite.animation != 'blow' or not sprite.playing:
		sprite.play('blow')

func _on_Bomb_body_entered(body):
	if not body is RigidPlayer and linear_velocity.length() > BLOW_SPEED:
		blowup()

func _on_AnimatedSprite_animation_finished():
	if sprite.animation == 'blow':
		queue_free()

