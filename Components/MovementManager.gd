class_name MovementManager extends Node

@export var moveSpeed := 3000.0

var lastMovedDirection := Vector2.ZERO
var direction := Vector2.ZERO

func _input(event: InputEvent) -> void:
	if Main.focusedNode and Main.focusedNode == get_parent() and Main.currentWorld.timeManager.timeScale == 1:
		direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
		
		if direction != Vector2.ZERO:
			lastMovedDirection = direction

func _physics_process(delta: float) -> void:
	if get_parent().state in [Utils.State.Dead, Utils.State.Sleeping]:
		return
	
	if (Main.focusedNode and Main.focusedNode != get_parent()) or Main.currentWorld.timeManager.timeScale != 1:
		direction = Vector2.ZERO
	
	get_parent().velocity = direction.normalized() * moveSpeed * (2 if Input.is_action_pressed("entity_run") else 1) * delta
	get_parent().move_and_slide()
