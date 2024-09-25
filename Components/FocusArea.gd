@tool
extends Area2D

@export var shape: Shape2D:
	set(value):
		shape = value
		$Collider.shape = value

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("node_focus") and Main.hoveredNode != get_parent() and Main.focusedNode == get_parent():
		Main.focusedNode = null

func onInputEvent(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if get_parent().state != Utils.State.Dead and event.is_action_pressed("node_focus") and Main.focusedNode != get_parent():
		Main.focusedNode = get_parent()

func onMouseEntered() -> void:
	Main.hoveredNode = get_parent()

func onMouseExited() -> void:
	Main.hoveredNode = null
