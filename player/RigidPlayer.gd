class_name RigidPlayer
extends RigidBody2D

const FLY_FORWARD_MULTILPLIER := 1
const FLY_BACK_MULTILPLIER := 3.0

var item_to_pick = null
var picked_item = null
var item_to_release = null
var is_dead = false
var joystick
var joystick_action
var _state: int = IDLE

var HIT_DAMAGE := 1.0
var MAX_HP = 10
var HP = MAX_HP

export var move_speed := 400.0
export var sfx_take_dmg: AudioStream
export var sfx_die: AudioStream
export var disabled = false
export var joystick_path : NodePath
export var joystick_action_path: NodePath


signal hp_change
signal dead

var directions: = {
	"TOP":  Vector2(0, -1),
	"DOWN": Vector2(0, 1),
	"LEFT": Vector2(-1, 0),
	"RIGHT": Vector2(1, 0)
}

enum {
	IDLE,
	MOVE
}

func _ready():
	if joystick_path:
		joystick = get_node(joystick_path)
	if joystick_action_path:
		joystick_action = get_node(joystick_action_path)
	$AnimatedSprite.play("fly")
	emit_signal("hp_change", HP)

func _process(delta):
	if disabled:
		return
	if is_dead:
		if Input.is_action_just_pressed("restart"):
			get_tree().reload_current_scene()
		return
	if not picked_item and is_attack_pressed() and item_to_pick:
		pickup_item(item_to_pick)
	if is_attack_released() and picked_item:
		release_item()

func is_attack_pressed():
	var is_pressed = false
	if joystick_action:
		is_pressed = joystick_action.is_pressed
		if is_pressed:
			return is_pressed
	return Input.is_action_pressed("attack")

func is_attack_released():
	var is_released = false
	if joystick_action:
		is_released = joystick_action.is_released
		if is_released:
			return is_released
	return Input.is_action_just_released("attack")
	
func _physics_process(delta):
	if disabled:
		return
	if is_dead:
		return
		
	var move_dir = Vector2.ZERO
	if joystick:
		move_dir = joystick.get_direction()
	else:
		move_dir = get_move_direction()
	
	var fly_multiplayer = FLY_FORWARD_MULTILPLIER
	if move_dir.dot(linear_velocity) < 0:
		fly_multiplayer = FLY_BACK_MULTILPLIER
	apply_central_impulse(move_dir * fly_multiplayer)
	
#	var move_dir = Vector2.ZERO
#	if joystick:
#		move_dir = joystick.get_direction()
#	if Input.is_action_pressed("move_top"):
#		move_dir += directions.get("TOP")
#	if Input.is_action_pressed("move_down"):
#		move_dir += directions.get("DOWN")
#	if Input.is_action_pressed("move_left"):
#		move_dir += directions.get("LEFT")
#	if Input.is_action_pressed("move_right"):
#		move_dir += directions.get("RIGHT")
#	$AnimatedSprite.flip_h = linear_velocity.x < 0
#	apply_central_impulse(move_dir)
#	slope_aside(move_dir.x)

#func _integrate_forces(state):
#	var move_dir = get_move_direction()
#	state.linear_velocity = move_dir * move_speed
#	if not move_dir.x:
#		state.linear_velocity.x = 0
#	if not move_dir.y:
#		state.linear_velocity.y = 0
#
	
		
	

func get_move_direction():
	return Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_down") - Input.get_action_strength("move_top")
	)

func take_damage(dmg: int, direction = Vector2(0, 0)):
	changeHP(-dmg)
	$AnimationPlayer.play("take_damage")
	$Blood.emitting = true
	apply_central_impulse(direction)
	if HP <= 0:
		die()
	else:
		play_sfx(sfx_take_dmg)

func slope_aside(x):
	var sprite = $AnimatedSprite
	if x > 0:
		sprite.rotation_degrees = 15
	elif x < 0:
		sprite.rotation_degrees = -15
	else:
		sprite.rotation_degrees = 0

func die():
	$AnimatedSprite.play("die")
	is_dead = true
	play_sfx(sfx_die)
	emit_signal("dead")

func changeHP(value):
	HP = min(HP + value, MAX_HP) if value >= 0 else max(HP + value, 0)
	emit_signal("hp_change", HP)

func _on_PowerUpPicker_body_entered(body):
	if body is HealPotion and HP < MAX_HP:
		changeHP(1)
		play_sfx(body.get_pick_up_sfx())
		body.queue_free()

func _on_ObjectPicker_body_entered(body):
	if not picked_item and body is PickablObject:
		item_to_pick = body

func pickup_item(item: PickablObject):
	item_to_release = load(item.get_normal_item_path())
	picked_item = item.get_picket_item_sceene().instance()
	picked_item.position = Vector2(0, 10)
	add_child(picked_item)
	item.queue_free()

func release_item():
	picked_item.queue_free()
	picked_item = null
	var droped_item = item_to_release.instance()
	droped_item.position = global_position + (linear_velocity.normalized() * 10)
	get_tree().get_current_scene().add_child(droped_item)
	droped_item.apply_central_impulse(linear_velocity * 1.5)
	apply_central_impulse(-linear_velocity / 2)
	item_to_release = null

func play_sfx(stream: AudioStream):
	$AudioPlayer.stream = stream
	$AudioPlayer.play()

func _on_ObjectPicker_body_exited(body):
	item_to_pick = null
	

func hit_enemy(body: Node2D):
	if body is Enemy:
		var force = linear_velocity.length()
		var damage = HIT_DAMAGE * ceil((force / 40))
		if damage > 1:
			take_damage(1)
			body.take_damage(damage - 1)
			body.push(position.direction_to(body.position))
