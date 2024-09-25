extends Node

var currentWorld: World
var currentArea: Utils.Area

var hoveredNode: Node = null
var focusedNode: Node = null:
	set(value):
		focusedNode = value
		
		if value is Local:
			Main.currentWorld.localInfoInterface.local = Main.focusedNode
		else:
			Main.currentWorld.localInfoInterface.local = null
