class_name Local extends CharacterBody2D

@onready var animationPlayer := $AnimationPlayer
@onready var ageManager: AgeManager = $AgeManager
@onready var movementManager: MovementManager = $MovementManager

@onready var spriteShirt := $Sprites/SpriteShirt
@onready var spritePants := $Sprites/SpritePants
@onready var spriteShoes := $Sprites/SpriteShoes
@onready var spriteHair := $Sprites/SpriteHair
@onready var spriteHead := $Sprites/SpriteHead
@onready var spriteTorso := $Sprites/SpriteTorso
@onready var spriteArms := $Sprites/SpriteArms
@onready var spriteLegs := $Sprites/SpriteLegs

@export_category("Properties")
@export var world: World
@export var sex: Utils.Sex
@export var fullName: String
@export var occupation: Utils.LocalOccupation

@export_category("Colors")
@export var skinColor: Color
@export var hairColor: Color
@export var shirtColor: Color
@export var pantsColor: Color
@export var shoesColor: Color

@export_category("Look")
@export var shirt: int
@export var pants: int
@export var shoes: int
@export var hair: int

@export_category("State")
@export var state: Utils.State

func initialize(world: World, sex: Utils.Sex, fullName: String, occupation: Utils.LocalOccupation, skinColor: Color, hairColor: Color) -> void:
	self.world = world
	self.sex = sex
	self.fullName = fullName
	self.occupation = occupation
	self.skinColor = skinColor
	self.hairColor = hairColor

var faith := 1.0

var moodletHunger: Utils.MoodletHunger
var motiveHunger := 1.0:
	set(value):
		if value <= 0.0:
			die()
			return
		
		motiveHunger = clampf(value, 0.0, 1.0)
		moodletHunger = setMoodlet(value)

var moodletThirst: Utils.MoodletThirst
var motiveThirst := 1.0:
	set(value):
		if value <= 0.0:
			die()
			return
		
		motiveThirst = clampf(value, 0.0, 1.0)
		moodletThirst = setMoodlet(value)

var moodletEnergy: Utils.MoodletEnergy
var motiveEnergy := 1.0:
	set(value):
		if value <= 0.0:
			state = Utils.State.Sleeping
			return
		
		motiveEnergy = clampf(value, 0.0, 1.0)
		moodletEnergy = setMoodlet(value)

func setMoodlet(value: float):
	return 0

func die():
	if Main.focusedNode == self:
		Main.focusedNode = null
	
	state = Utils.State.Dead
	process_mode = PROCESS_MODE_DISABLED

func _ready() -> void:
	ageManager.lifespanSeconds = Utils.timeUnitsToSeconds(Utils.TimeUnit.Year) * 40
	shoes = 1
	pants = 1
	shirt = 1
	hair = sex + 1
	shoesColor = Color("453018")
	pantsColor = Color("292e55") if sex == Utils.Sex.Male else Color("4b4faa")
	shirtColor = Color("7d0f0f") if sex == Utils.Sex.Male else Color("588842")
	
	spriteHead.self_modulate = skinColor
	spriteTorso.self_modulate = skinColor
	spriteArms.self_modulate = skinColor
	spriteLegs.self_modulate = skinColor
	spriteShoes.self_modulate = shoesColor
	spritePants.self_modulate = pantsColor
	spriteShirt.self_modulate = shirtColor
	spriteHair.self_modulate = hairColor

func _physics_process(delta: float) -> void:
	spriteHead.texture = load("res://Local/{}/Head{}.png".format([Utils.State.keys()[state], Utils.State.keys()[state]], "{}"))
	spriteTorso.texture = load("res://Local/{}/Torso{}.png".format([Utils.State.keys()[state], Utils.State.keys()[state]], "{}"))
	spriteArms.texture = load("res://Local/{}/Arms{}.png".format([Utils.State.keys()[state], Utils.State.keys()[state]], "{}"))
	spriteLegs.texture = load("res://Local/{}/Legs{}.png".format([Utils.State.keys()[state], Utils.State.keys()[state]], "{}"))
	spriteShoes.texture = load("res://Local/{}/Shoes{}{}.png".format([Utils.State.keys()[state], shoes, Utils.State.keys()[state]], "{}"))
	spritePants.texture = load("res://Local/{}/Pants{}{}.png".format([Utils.State.keys()[state], pants, Utils.State.keys()[state]], "{}"))
	spriteShirt.texture = load("res://Local/{}/Shirt{}{}.png".format([Utils.State.keys()[state], shirt, Utils.State.keys()[state]], "{}"))
	spriteHair.texture = load("res://Local/{}/Hair{}{}.png".format([Utils.State.keys()[state], sex + 1, Utils.State.keys()[state]], "{}"))
	
	animationPlayer.play(Utils.State.keys()[state] + Utils.Direction.keys()[Utils.vectorToDirection(movementManager.lastMovedDirection)])
	
	motiveHunger -= (world.timeManager.ingameTimestamp - world.timeManager.oldIngameTimestamp) / (Utils.timeUnitsToSeconds(Utils.TimeUnit.Day, 55) * (2 if state == Utils.State.Sleeping else 1))
	motiveThirst -= (world.timeManager.ingameTimestamp - world.timeManager.oldIngameTimestamp) / (Utils.timeUnitsToSeconds(Utils.TimeUnit.Day, 3) * (2 if state == Utils.State.Sleeping else 1))
	motiveEnergy -= (world.timeManager.ingameTimestamp - world.timeManager.oldIngameTimestamp) / (Utils.timeUnitsToSeconds(Utils.TimeUnit.Day) * (-0.33 if state == Utils.State.Sleeping else 1))
	
	if state == Utils.State.Dead:
		return
	
	if world.timeManager.ingameDateTimeObject.Hour > 1 and world.timeManager.ingameDateTimeObject.Hour < 7:
		state = Utils.State.Sleeping
	else:
		state = Utils.State.None
