extends RigidBody2D


func _physics_process(delta: float) -> void:
	linear_velocity += $"..".gravity * delta

func Die():
	var particle = $Death
	particle.reparent($"..")
	particle.emitting = true
	$"..".Enemy_Count -= 1
	queue_free()
