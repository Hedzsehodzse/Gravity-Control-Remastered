extends Sprite2D

@export var Door: Node
@export var No_Disactivation: bool = false
@onready var actual_door = Door.get_node("Area2D")

var active: bool = true


func Body_Entered(body: Node2D) -> void:
	if body.is_in_group("Player") and active:
		if !No_Disactivation:
			modulate = Color("ff0000ff")
			scale *= 0.8
			active = false
		actual_door.Activate()
		$"../../..".Play_Sound(load("res://Sounds/Door_Button.mp3"), 0, global_position)
