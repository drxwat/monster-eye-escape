extends Node2D

export var LIGHT_RADIUS = 40

signal on_illuminated_start
signal on_illuminated_end

var intruder = null
var is_alarmed = false
var alarmed_guards = []

var light_scate2shape_radius_ratio = 20
var alart2light_radius = 2

func _ready():
	var light_shape = CircleShape2D.new()
	light_shape.radius = LIGHT_RADIUS
	$LightArea/CollisionShape2D.shape = light_shape
	
	var alarm_shape = CircleShape2D.new()
	alarm_shape.radius = LIGHT_RADIUS * alart2light_radius
	$AlarmArea/CollisionShape2D.shape = alarm_shape
	
	$Light2D.texture_scale = LIGHT_RADIUS / light_scate2shape_radius_ratio
	
func _physics_process(delta):
	if not intruder or is_alarmed:
		return
	call_guards()
	is_alarmed = true

func emit_lum_start(body):
	intruder = body
	emit_signal("on_illuminated_start")
	
func emit_lum_end(body):
	intruder = null
	is_alarmed = false
	release_guards(body.global_position)
	emit_signal("on_illuminated_end")
	
func call_guards():
	var area_guards = $AlarmArea.get_overlapping_bodies()
	var space_state = get_world_2d().direct_space_state
	for guard in area_guards:
		var res = space_state.intersect_ray(global_position, guard.global_position, [self], 
		  $AlarmArea.collision_mask)
		var guards_group = []
		if res.has("collider") and res["collider"].has_method("set_target"):
			guards_group.append(weakref(res["collider"]))
			res["collider"].set_target(intruder)
		alarmed_guards = guards_group
#		

func release_guards(last_target_g_pos):
	for guard_ref in alarmed_guards:
		var guard = guard_ref.get_ref()
		if guard:
			guard.set_i_point(last_target_g_pos)
	alarmed_guards = []
## TODO: On enter patroling guard to AlarmArea set is_alarmed to false and call guards onec more
