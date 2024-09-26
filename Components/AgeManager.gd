class_name AgeManager extends Node

var lifespanSeconds: int
var birthTimestamp: int

var age: int:
	get:
		return Main.currentWorld.timeManager.ingameTimestamp - birthTimestamp

func _physics_process(delta: float) -> void:
	if !birthTimestamp:
		birthTimestamp = Main.currentWorld.timeManager.ingameTimestamp
	
	if age >= lifespanSeconds:
		get_parent().die()
