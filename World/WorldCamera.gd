extends Camera2D

const CAMERA_MOVE_SPEED := 750

var dragging := false
var dragStartPosition := Vector2.ZERO
var moveDirection := Vector2.ZERO

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("camera_drag_start"):
		dragStartPosition = get_global_mouse_position()
		dragging = true

	if event.is_action_released("camera_drag_start"):
		dragStartPosition = get_global_mouse_position()
		dragging = false
	
	if event.is_action_pressed("camera_zoom_in"):
		zoom = (zoom + Vector2(0.25, 0.25) * zoom).clamp(Vector2.ONE, Vector2(10, 10))
	
	if event.is_action_pressed("camera_zoom_out"):
		zoom = (zoom - Vector2(0.25, 0.25) * zoom).clamp(Vector2.ONE, Vector2(10, 10))
	
	if event.is_action_pressed("camera_zoom_reset"):
		zoom = Vector2.ONE
	
	moveDirection = Input.get_vector("move_left", "move_right", "move_up", "move_down")

func _physics_process(delta: float) -> void:
	if Main.focusedNode:
		global_position = global_position.lerp(Main.focusedNode.global_position, 0.25)
		return
	
	if (dragging):
		global_position -= (get_global_mouse_position() - dragStartPosition)
	else:
		global_position += moveDirection.normalized() / (zoom / 2) * CAMERA_MOVE_SPEED * delta
