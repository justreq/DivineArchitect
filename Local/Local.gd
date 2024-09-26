class_name Local extends CharacterBody2D

@onready var animationPlayer := $AnimationPlayer
@onready var ageManager: AgeManager = $AgeManager
@onready var movementManager: MovementManager = $MovementManager

@onready var spriteBody := $Sprites/SpriteBody
@onready var spritePants := $Sprites/SpritePants
@onready var spriteShoes := $Sprites/SpriteShoes
@onready var spriteArms := $Sprites/SpriteArms
@onready var spriteShirtBody := $Sprites/SpriteShirtBody
@onready var spriteShirtArms := $Sprites/SpriteShirtArms
@onready var spriteHair := $Sprites/SpriteHair

var textures := {}

var world: World
var sex: Utils.Sex
var fullName: String
var occupation: Utils.LocalOccupation

var skinColor: Color:
	set(value):
		skinColor = value

var hairColor: Color:
	set(value):
		hairColor = value

var shirtColor: Color:
	set(value):
		shirtColor = value

var pantsColor: Color:
	set(value):
		pantsColor = value

var shoesColor: Color:
	set(value):
		shoesColor = value

var shirt: int:
	set(value):
		shirt = value

var pants: int:
	set(value):
		pants = value

var shoes: int:
	set(value):
		shoes = value

var hair: int:
	set(value):
		hair = value

var state: Utils.State:
	set(value):
		state = value

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

func initialize(world: World, sex: Utils.Sex, fullName: String, occupation: Utils.LocalOccupation, skinColor: Color, hairColor: Color) -> void:
	self.world = world
	self.sex = sex
	self.fullName = fullName
	self.occupation = occupation
	self.skinColor = skinColor
	self.hairColor = hairColor

func loadTextures():
	for i in DirAccess.get_directories_at("res://Local/Textures"):
		for j in Array(DirAccess.get_files_at("res://Local/Textures/" + i)).filter(func(e): return e.get_extension() == "png"):
			textures[j.left(-4)] = load("res://Local/Textures/" + i + "/" + j)

func die():
	if Main.focusedNode == self:
		Main.focusedNode = null
	
	state = Utils.State.Dead
	process_mode = PROCESS_MODE_DISABLED

func _init() -> void:
	loadTextures()

func _ready() -> void:
	ageManager.lifespanSeconds = Utils.timeUnitsToSeconds(Utils.TimeUnit.Year) * 40
	hair = sex
	shoesColor = Color("453018")
	pantsColor = Color("292e55") if sex == Utils.Sex.Male else Color("4b4faa")
	shirtColor = Color("7d0f0f") if sex == Utils.Sex.Male else Color("588842")

func _physics_process(delta: float) -> void:
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
