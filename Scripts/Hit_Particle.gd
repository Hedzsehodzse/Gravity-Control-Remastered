extends GPUParticles2D


var Main: Node2D
var timer: float = 0


func _process(delta: float) -> void:
	process_material.gravity = Vector3(Main.gravity.x, Main.gravity.y, 0)
	timer += delta
	if timer > 2:
		queue_free()
