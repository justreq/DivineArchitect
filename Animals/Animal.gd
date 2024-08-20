class_name Animal extends CharacterBody2D

enum Sex {
	Male,
	Female
}

@export var world: World

@export var species: String
@export var sex := Sex.Male

@onready var sprite: Sprite2D = $Sprite2D
@onready var hurtbox: Area2D = $Hurtbox

@onready var rawMeat := preload("res://Items/RawMeat.tscn")

var birthTimestamp: int
var sleeping := false

func die():
	for i in range(4):
		var rawMeatInstance := rawMeat.instantiate()
		rawMeatInstance.global_position = global_position
		rawMeatInstance.linear_velocity = Vector2(100, 100) * Vector2(randi_range(-1, 1), randi_range(-1, 1))
		world.call_deferred("add_child", rawMeatInstance)

	queue_free()
	

func _ready() -> void:
	birthTimestamp = world.ingameTimestamp
	
	if sex == Sex.Female:
		match species:
			"Ox":
				sprite.region_rect = Rect2(48, 0, 48, 32)

func _on_hurtbox_area_entered(area: Area2D) -> void:
	if area.get_parent() is Local:
		die()
