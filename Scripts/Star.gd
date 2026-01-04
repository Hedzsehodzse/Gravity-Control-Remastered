extends Area2D


func _ready() -> void:
	$Anim.play("Wobble")

func Body_Entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		var particle = $Pop
		particle.reparent($"..")
		particle.emitting = true
		$"../..".Enemy_Count -= 1
		$"../..".Play_Sound(load("res://Sounds/Star.mp3"), 5, body.global_position)
		queue_free()
