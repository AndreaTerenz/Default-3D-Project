extends Node

static func transform_hdir(d: Vector2, transform: Transform3D) -> Vector3:
	return (transform.basis * Vector3(d.x, 0, d.y)).normalized()
