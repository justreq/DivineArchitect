class_name Local extends CharacterBody2D

@onready var Sprite := $Sprite

@export var sex: Utils.Sex:
	get:
		return sex
	set(value):
		sex = value
		SetSprite()

func SetSprite() -> void:
	if Sprite:
			Sprite.texture = load("res://Local/Local{}.png".format([Utils.Sex.keys()[sex]], "{}"))

func _ready() -> void:
	SetSprite()
