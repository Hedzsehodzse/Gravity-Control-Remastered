extends CharacterBody2D


@export var Speed: float = 100
@onready var Main: Node2D = get_parent()


func _ready() -> void:
	$Death.process_material.color = $Sprite.modulate


func _physics_process(_delta: float) -> void:
	if Main.has_node("Ball"):
		$Agent.target_position = %Ball.global_position
		var next_pos = $Agent.get_next_path_position()
		
		velocity = (next_pos - global_position).normalized() * Speed
		look_at(next_pos)
		move_and_slide()
		
func Die():
	var particle = $Death
	particle.reparent($"..")
	particle.emitting = true
	Main.Enemy_Count -= 1
	var num = str(randi_range(1, 4))
	Main.Play_Sound(load("res://Sounds/Death" + num + ".mp3"), -5, global_position)
	queue_free()
