extends Node

var currentWorld: World
var currentArea: Utils.Area

func _ready() -> void:
	currentWorld = get_tree().current_scene
	
	var allSeeingEye := AllSeeingEye.new()
	currentWorld.add_child(allSeeingEye)
