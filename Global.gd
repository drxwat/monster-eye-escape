extends Node

## TAKEN FROM GODOT DOC https://docs.godotengine.org/en/3.2/getting_started/step_by_step/singletons_autoload.html

var current_scene = null
var nav: Navigation2D #Seted by Nav2d itself
var title_screen: Control

var show_pause_sceen = false
var is_game_started = false

func _ready():
	pause_mode = Node.PAUSE_MODE_PROCESS
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() - 1)

func _process(delta):
	if is_game_started and Input.is_action_just_pressed("ui_cancel"):
		toggle_pause()

func goto_scene(scene: PackedScene):
	# This function will usually be called from a signal callback,
	# or some other function in the current scene.
	# Deleting the current scene at this point is
	# a bad idea, because it may still be executing code.
	# This will result in a crash or unexpected behavior.

	# The solution is to defer the load to a later time, when
	# we can be sure that no code from the current scene is running:

	call_deferred("_deferred_goto_scene", scene)

func toggle_pause():
	show_pause_sceen = !show_pause_sceen
	if title_screen:
		if show_pause_sceen:
			title_screen.show()
		else:
			title_screen.hide()
	get_tree().paused = show_pause_sceen

func start_new_game():
	is_game_started = true
	var start_sceene_path = "res://levels/Intro.tscn"
	var start_scene = load(start_sceene_path)
	goto_scene(start_scene)
	
func exit_game():
	get_tree().quit()

func _deferred_goto_scene(scene: PackedScene):
	# It is now safe to remove the current scene
	current_scene.free()

	# Instance the new scene.
	current_scene = scene.instance()

	# Add it to the active scene, as child of root.
	get_tree().get_root().add_child(current_scene)

	# Optionally, to make it compatible with the SceneTree.change_scene() API.
	get_tree().set_current_scene(current_scene)

func get_nav_path(point1, point2):
	return nav.get_simple_path(point1, point2)
	
