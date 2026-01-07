extends Area2D


func _ready() -> void:
	$Anim.play("Wobble")

func Body_Entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		var particle = $Pop
		particle.reparent($"..")
		particle.emitting = true
		if is_in_group("Red_Star"):
			$"../..".Special_Enemy_Count -= 1
		else:
			$"../..".Enemy_Count -= 1
		$"../..".Update_Star_Counter()
		$"../..".Play_Sound(load("res://Sounds/Star.mp3"), 5, body.global_position)
		queue_free()
