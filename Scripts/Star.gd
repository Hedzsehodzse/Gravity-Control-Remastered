extends Area2D


var tres: int = 12

func _ready() -> void:
	$Anim.play("Wobble")

func Body_Entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		var particle = $Pop
		particle.reparent($"..")
		particle.emitting = true
		var Main = $"../.."
		
		if Main.Tutorial:
			var tut = Main.get_node("Hover_Texts")
			tut.Stars_Collected += 1
			if tut.Stars_Collected == tres:
				tut.Stars_Collected = 0
				tut.Next_Task()
		else:
			if is_in_group("Red_Star"):
				Main.Special_Enemy_Count -= 1
			else:
				Main.Enemy_Count -= 1
			Main.Update_Star_Counter()
		
		Main.Play_Sound(load("res://Sounds/Star.mp3"), 5, body.global_position)
		queue_free()
