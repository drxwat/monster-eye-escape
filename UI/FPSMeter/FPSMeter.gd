extends HBoxContainer

const FPS_TIMER_LIMIT = 2.0
var fps_timer = 0.0

func _process(delta):
	fps_timer += delta
	if fps_timer > FPS_TIMER_LIMIT:
		fps_timer = 0.0
		$FPSValue.text = str(Engine.get_frames_per_second())
