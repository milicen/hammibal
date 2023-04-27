extends CPUParticles2D


func _on_timer_timeout():
	set_process(false)
	set_process_internal(false)
	set_physics_process(false)
	set_physics_process_internal(false)
