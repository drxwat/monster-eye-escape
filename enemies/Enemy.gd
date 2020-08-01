class_name Enemy
extends KinematicBody2D

export var SPEED = 25
export var HP = 5 setget setHP
export var take_dmg_sfx: AudioStream
export var die_sfx: AudioStream
export var disabled = false

var target setget set_target
var point_of_interest setget set_i_point
var is_chasing = false
var is_attacking = false
var is_dead = false
var push_dir = null
var nav_path = null

var DISTANCE_MARGIN = 5

func _ready():
	initialize()

func _process(delta):
	if disabled:
		return
	if is_dead:
		$CollisionShape2D.disabled = true
		return

	if target and "is_dead" in target and target.is_dead:
		set_target(null)

	if push_dir:
		idle()
		move_and_collide(push_dir * SPEED * delta)
		return
	
	if nav_path and nav_path.empty():
		nav_path = null

#	if nav_path and not nav_path.empty():
#		move_along_path(delta)
#		return

	if is_chasing:
		chase(target)
	elif nav_path and not nav_path.empty():
		move_along_path(delta)
	elif point_of_interest:
		if global_position.distance_to(point_of_interest) <= DISTANCE_MARGIN:
			set_i_point(null)
			return
		move_to_point(point_of_interest)
	else:
		idle()
		
	if is_attacking:
		attack(target)

func set_target(value):
	nav_path = null
	target = value
	if value:
		is_chasing = true
		point_of_interest = null
	else:
		is_chasing = false
	
func set_i_point(value):
	point_of_interest = value

func target_gone_in_shadow(last_gp_point):
	if $GuardArea.get_overlapping_bodies().empty():
		set_target(null)
		set_i_point(last_gp_point)
	
func take_damage(dmg: int):
	setHP(HP - min(dmg, HP))
	if HP <= 0:
		die()
	else:
		play_sfx(take_dmg_sfx)
			
		
func push(direction: Vector2, time = 1.5):
	push_dir = direction
	$StunTimer.start(time)

func chase(target):
	move_to_point(target.global_position)

func move_along_path(delta):
	var distance = SPEED * delta
	for i in range(nav_path.size()):
		var next_point = nav_path[0]
		rotate_to_point(next_point)
		var dist_to_next_point = position.distance_to(next_point)
		if distance <= dist_to_next_point and distance >= 0.0:
			move_and_slide(position.direction_to(next_point).normalized() * SPEED)
			break
		distance -= dist_to_next_point
		move_and_slide(position.direction_to(next_point).normalized() * SPEED)
		nav_path.remove(0)

func set_path(path):
	nav_path = path
	
func move_to_point(point_gp):
#	$Graphix.scale = Vector2(1 if target_dir.x >= 0 else -1, 1)
	rotate_to_point(point_gp)
	var target_dir = global_position.direction_to(point_gp).normalized()
	move_and_slide(target_dir * SPEED)
	
func idle():
	pass
	
func die():
	is_dead = true
	play_sfx(die_sfx)

func initialize():
	setHP(HP)
	
func attack(target):
	pass
	
func setHP(value):
	HP = value
	$HPBar.points = PoolVector2Array([Vector2.ZERO, Vector2(HP*2, 0)])

func rotate_to_point(point_position):
	var dir = global_position.direction_to(point_position)
	$Graphix.scale = Vector2(1 if dir.x >= 0 else -1, 1)

func play_sfx(stream: AudioStream):
	$AudioStreamPlayer2D.stream = stream
	$AudioStreamPlayer2D.play()
	
func _on_GuardArea_body_entered(body):
#	var path = Global.get_nav_path(position, body.position)
#	set_path(path)
	set_target(body)
#	is_chasing = true

func _on_GuardArea_body_exited(body):
	set_target(null)
#	is_chasing = false

func _on_AttackArea_body_entered(body):
	is_attacking = true

func _on_AttackArea_body_exited(body):
	is_attacking = false

func _on_Timer_timeout():
	push_dir = null
