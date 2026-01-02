extends Area2D



func Body_Entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		var main: Node = body.get_parent()
		
		if body.has_node("Camera2D"):
			var camera = body.get_node("Camera2D")
			camera.reparent(body.get_parent())
			
		if body.has_node("Death"):
			var particle = body.get_node("Death")
			particle.reparent(main)
			particle.emitting = true

		if !main.won:
			main.Lose()
			
		var num = str(randi_range(1, 4))
		main.Play_Sound(load("res://Sounds/Death" + num + ".mp3"), -5, body.global_position)
			
		body.queue_free()
