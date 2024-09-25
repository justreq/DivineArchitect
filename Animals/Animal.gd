class_name Animal extends CharacterBody2D

@onready var ageManager: AgeManager = $AgeManager
@onready var sprite := $Sprite

@export_category("Constants")
@export var world: World
@export var type: Utils.AnimalType
@export var sex: Utils.Sex
@export var fullName: String

@export_category("State")
@export var state: Utils.State:
	set(value):
		state = value

func die():
	if Main.focusedNode == self:
		Main.focusedNode = null
	
	state = Utils.State.Dead
	process_mode = PROCESS_MODE_DISABLED

func initialize(world: World, type: Utils.AnimalType, sex: Utils.Sex, fullName: String) -> void:
	self.world = world
	self.type = type
	self.sex = sex
	self.fullName = name

func _ready() -> void:
	ageManager.lifespanSeconds = Utils.timeUnitsToSeconds(Utils.TimeUnit.Year) * Utils.ANIMAL_LIFESPANS[type]
	sprite.texture = load("res://Animals/{}{}.png".format([Utils.AnimalType.keys()[type], Utils.Sex.keys()[sex]], "{}"))
