extends StaticBody2D


@export var node: Node
@export var speed: float = 1


func _process(delta: float) -> void:
	node.global_rotation += PI * delta * speed
