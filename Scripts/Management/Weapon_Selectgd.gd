extends Panel

enum weapons {LASER, ROCKET}
@export var Weapon: weapons
@onready var Main: Node = $"../../.."
@onready var Ball: RigidBody2D = $"../../../Ball"
@onready var UI: CanvasLayer = $"../.."



func Entered() -> void:
	$Anim.play("In")
	UI.Play_Sound(load("res://Sounds/Hover.mp3"), -10, Ball.global_position)


func Exited() -> void:
	$Anim.play("Out")


func Pressed() -> void:
	get_tree().paused = false
	UI.Play_Sound(load("res://Sounds/Select.mp3"), -10, Ball.global_position)
	Ball.Weapon = Weapon
	Ball._ready()
	$"..".visible = false
