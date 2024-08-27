class_name Animal extends CharacterBody2D

@onready var Sprite := $Sprite

@export var sex: Utils.Sex:
	get:
		return sex
	set(value):
		sex = value
		SetSprite()

@export var type: Utils.AnimalType:
	get:
		return type
	set(value):
		type = value
		SetSprite()

func SetSprite() -> void:
	if Sprite:
		Sprite.texture = load("res://Animals/{}{}.png".format([Utils.AnimalType.keys()[type], Utils.Sex.keys()[sex]], "{}"))

func _ready() -> void:
	SetSprite()
