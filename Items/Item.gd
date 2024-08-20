class_name Item extends RigidBody2D

@onready var grabArea: Area2D = $GrabArea
var grabbable := false
var dropped := true

func _process(delta: float) -> void:
	if linear_velocity <= Vector2(0.01, 0.01):
		grabbable = true
