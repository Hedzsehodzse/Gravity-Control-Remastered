extends RigidBody2D


@export var time: float = 1000000
var timer: float = 0


func _physics_process(delta: float) -> void:
	linear_velocity += $"..".gravity * delta
	
	timer += delta
	if timer > time:
		queue_free()

func Die():
	var particle = $Death
	particle.reparent($"..")
	particle.emitting = true
	$"..".Enemy_Count -= 1
	queue_free()
