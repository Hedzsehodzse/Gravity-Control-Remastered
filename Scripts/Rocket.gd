extends CharacterBody2D


@export var Web_Test: bool = false
@export var SPEED = 300.0


func _physics_process(delta: float) -> void:
	if !Web_Test:
		look_at(get_global_mouse_position())
		global_rotation += PI / 2
		velocity += (get_global_mouse_position() - global_position).normalized() * SPEED * delta
		move_and_slide()


func Body_Entered(body: Node2D) -> void:
	if !body.is_in_group("Player"):
		for i in range($Cast.get_collision_count()):
			var collider = $Cast.get_collider(i)
			collider.Die()
		if has_node("Explosion") and has_node("Smoke"):
			Save_Particle($Explosion, true)
			Save_Particle($Smoke, false)
			Save_Particle($Smoke2, false)
		$"..".Play_Sound(load("res://Sounds/Explosion.mp3"), 0 , global_position)
		queue_free()
			
			
func Save_Particle(particle: GPUParticles2D, emitting: bool):
	particle.reparent($"..")
	particle.emitting = emitting
