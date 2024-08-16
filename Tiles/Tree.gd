extends StaticBody2D

enum TreeType {
	Normal,
	Trunk
}

@export var Type := TreeType.Normal

@onready var sprite := $Sprite2D

func _ready() -> void:
	if Type == TreeType.Trunk:
		sprite.region_rect = Rect2(48, 48, 16, 16)
