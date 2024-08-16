extends CharacterBody2D

enum Sex {
	Male,
	Female
}

@export var sex := Sex.Male
@export var daysOld := 25

@onready var sprite := $Sprite2D

func _ready() -> void:
	if sex == Sex.Female:
		sprite.region_rect = Rect2(16, 0, 16, 32)
