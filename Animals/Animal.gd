class_name Animal extends CharacterBody2D

enum Sex {
	Male,
	Female
}

@export var world: World

@export var species: String
@export var sex := Sex.Male

@onready var sprite: Sprite2D = $Sprite2D

var birthTimestamp: int
var sleeping := false

func _ready() -> void:
	birthTimestamp = world.ingameTimestamp
	
	if sex == Sex.Female:
		match species:
			"Ox":
				sprite.region_rect = Rect2(48, 0, 48, 32)
