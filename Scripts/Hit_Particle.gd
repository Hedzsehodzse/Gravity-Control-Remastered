extends GPUParticles2D

@export var Web_Test: bool = false

var Main: Node2D
var timer: float = 0


func _process(delta: float) -> void:
	if !Web_Test:
		process_material.gravity = Vector3(Main.gravity.x, Main.gravity.y, 0)
		timer += delta
		if timer > 2:
			queue_free()
