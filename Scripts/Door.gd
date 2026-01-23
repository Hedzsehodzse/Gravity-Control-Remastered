extends Area2D

@export var Open: bool = false
@onready var main = get_parent()
@onready var frame = main.get_node("Frame")
@onready var base_pos = main.global_position

func _ready() -> void:
	if Open:
		main.global_position += Vector2(70, 0).rotated(main.global_rotation)
		frame.modulate = Color("#2b8025")
	else:
		frame.modulate = Color("#861200")

func Activate():
	var pos_tween = create_tween()
	#var color_tween = create_tween()
	if Open:
		pos_tween.tween_property(main, "global_position", base_pos, 1)
		frame.modulate = Color("#861200")
		#color_tween.tween_property(frame, "self_modulate", Color("#861200"), 0.2)
		Open = false
	else:
		pos_tween.tween_property(main, "global_position", base_pos + Vector2(70, 0).rotated(main.global_rotation), 1)
		frame.modulate = Color("#2b8025")
		#color_tween.tween_property(frame, "self_modulate", Color("#2b8025"), 0.2)
		Open = true
	$Timer.start()
	$"../../../..".Play_Sound(load("res://Sounds/Door.mp3"), -5, global_position)

func Timeout() -> void:
	$"../../..".bake_navigation_polygon()
