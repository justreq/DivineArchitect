class_name AgeManager extends Node

var lifespanSeconds: int
var birthTimestamp: int

var age: int:
	get:
		return Main.currentWorld.timeManager.ingameTimestamp - birthTimestamp

func _ready() -> void:
	birthTimestamp = Main.currentWorld.timeManager.ingameTimestamp

func _physics_process(delta: float) -> void:
	if age >= lifespanSeconds:
		get_parent().die()
