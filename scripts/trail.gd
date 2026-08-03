extends GPUParticles3D

func update_dir(dir: Vector3) -> void:
	look_at(
		global_position + dir.normalized(),
	)
	rotate_object_local(Vector3.RIGHT, deg_to_rad(90))
