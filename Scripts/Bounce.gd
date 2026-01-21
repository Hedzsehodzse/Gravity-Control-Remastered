extends StaticBody2D

enum types {DEFAULT, STICKY, BOUNCY, ULTRA_BOUNCY}
@export var Type: types 
@export var Open: bool = false


func _ready() -> void:
	if Open:
		$Area2D.Open = true
		$Area2D._ready()


func Body_Entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		if body.linear_velocity.length() > 70:
			var main = body.get_parent()
			if Type == types.DEFAULT:
				var num = str(randi_range(1, 10))
				main.Play_Sound(load("res://Sounds/Hit" + num + ".mp3"), 3, body.global_position)
			if Type == types.STICKY:
				main.Play_Sound(load("res://Sounds/Bouncy.mp3"), 3, body.global_position)
			if Type == types.BOUNCY:
				main.Play_Sound(load("res://Sounds/Bouncy.mp3"), 3, body.global_position)
			if Type == types.ULTRA_BOUNCY:
				main.Play_Sound(load("res://Sounds/Boost.mp3"), 3, body.global_position)
		if Type == types.ULTRA_BOUNCY:
			body.linear_velocity *= 2
	if body.is_in_group("Saw"):
		if body.linear_velocity.length() > 70:
			var main = body.get_parent()
			var num = str(randi_range(1, 8))
			main.Play_Sound(load("res://Sounds/Metal" + num + ".mp3"), 0, body.global_position)
		if Type == types.ULTRA_BOUNCY:
			body.linear_velocity *= 2
