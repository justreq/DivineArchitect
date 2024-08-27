extends StaticBody2D

@onready var Sprite := $Sprite

@export var frame: Utils.TreeFrame:
	get:
		return frame
	set(value):
		frame = value
		
		if Sprite:
			Sprite.frame = value
