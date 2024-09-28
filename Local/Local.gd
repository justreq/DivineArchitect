class_name Local extends CharacterBody2D

@onready var animationPlayer := $AnimationPlayer
@onready var ageManager: AgeManager = $AgeManager
@onready var movementManager: MovementManager = $MovementManager

@onready var spriteBody := $Sprites/SpriteBody
@onready var spriteShoes := $Sprites/SpriteShoes
@onready var spritePants := $Sprites/SpritePants
@onready var spriteShirtBody := $Sprites/SpriteShirtBody
@onready var spriteHair := $Sprites/SpriteHair
@onready var spriteArms := $Sprites/SpriteArms
@onready var spriteShirtArms := $Sprites/SpriteShirtArms

var textures := {}

@export_category("Properties")
@export var world: World
@export var sex: Utils.Sex
@export var fullName: String
@export var occupation: Utils.LocalOccupation
@export var state: Utils.State:
	set(value):
		if state == value:
			return
		
		state = value
		setAnimation()
		setTextures()

@export_category("Colors")
@export var skinColor: Color:
	set(value):
		skinColor = value
		$Sprites/SpriteBody.self_modulate = value
		$Sprites/SpriteArms.self_modulate = value

@export var hairColor: Color:
	set(value):
		hairColor = value
		$Sprites/SpriteHair.self_modulate = value

@export var shirtBodyColor: Color:
	set(value):
		shirtBodyColor = value
		$Sprites/SpriteShirtBody.self_modulate = value

@export var shirtArmsColor: Color:
	set(value):
		shirtArmsColor = value
		$Sprites/SpriteShirtArms.self_modulate = value

@export var pantsColor: Color:
	set(value):
		pantsColor = value
		$Sprites/SpritePants.self_modulate = value

@export var shoesColor: Color:
	set(value):
		shoesColor = value
		$Sprites/SpriteShoes.self_modulate = value

@export_category("Clothing")
@export var shirt: int:
	set(value):
		shirt = value
		$Sprites/SpriteShirtBody.texture = textures["Shirt" + str(shirt) + "Body" + Utils.State.keys()[state]]
		$Sprites/SpriteShirtArms.texture = textures["Shirt" + str(shirt) + "Arms" + Utils.State.keys()[state]]

@export var pants: int:
	set(value):
		pants = value
		$Sprites/SpritePants.texture = textures["Pants" + str(value) + Utils.State.keys()[state]]

@export var shoes: int:
	set(value):
		shoes = value
		$Sprites/SpriteShoes.texture = textures["Shoes" + str(value) + Utils.State.keys()[state]]

@export var hair: int:
	set(value):
		hair = value
		$Sprites/SpriteHair.texture = textures["Hair" + str(value) + Utils.State.keys()[state]]

@export_category("Motives")
@export var faith := 1.0

var moodletHunger: Utils.MoodletHunger
@export var motiveHunger := 1.0:
	set(value):
		if value <= 0.0:
			die()
			return
		
		motiveHunger = clampf(value, 0.0, 1.0)
		moodletHunger = setMoodlet(value)

var moodletThirst: Utils.MoodletThirst
@export var motiveThirst := 1.0:
	set(value):
		if value <= 0.0:
			die()
			return
		
		motiveThirst = clampf(value, 0.0, 1.0)
		moodletThirst = setMoodlet(value)

var moodletEnergy: Utils.MoodletEnergy
@export var motiveEnergy := 1.0:
	set(value):
		if value <= 0.0:
			state = Utils.State.Sleeping
			return
		
		motiveEnergy = clampf(value, 0.0, 1.0)
		moodletEnergy = setMoodlet(value)

func setMoodlet(value: float):
	return 0

func loadTextures() -> void:
	for i in DirAccess.get_directories_at("res://Local/Textures"):
		for j in Array(DirAccess.get_files_at("res://Local/Textures/" + i)).filter(func(e): return e.get_extension() == "png"):
			textures[j.left(-4)] = load("res://Local/Textures/" + i + "/" + j)

func setTextures() -> void:
	spriteBody.texture = textures["Body" + Utils.State.keys()[state]]
	spriteShoes.texture = textures["Shoes" + str(shoes) + Utils.State.keys()[state]]
	spritePants.texture = textures["Pants" + str(pants) + Utils.State.keys()[state]]
	spriteShirtBody.texture = textures["Shirt" + str(shirt) + "Body" + Utils.State.keys()[state]]
	spriteHair.texture = textures["Hair" + str(hair) + Utils.State.keys()[state]]
	spriteArms.texture = textures["Arms" + Utils.State.keys()[state]]
	spriteShirtArms.texture = textures["Shirt" + str(shirt) + "Arms" + Utils.State.keys()[state]]

func setAnimation() -> void:
	animationPlayer.play(Utils.State.keys()[state] + Utils.Direction.keys()[Utils.vectorToDirection(movementManager.lastMovedDirection)])

func die() -> void:
	if Main.focusedNode == self:
		Main.focusedNode = null
	
	state = Utils.State.Dead
	process_mode = PROCESS_MODE_DISABLED

func _init() -> void:
	loadTextures()

func _ready() -> void:
	movementManager.directionChanged.connect(setAnimation)
	setTextures()
	ageManager.lifespanSeconds = Utils.timeUnitsToSeconds(Utils.TimeUnit.Year) * 40

func _physics_process(delta: float) -> void:
	if state == Utils.State.None and movementManager.direction == Vector2.ZERO:
		animationPlayer.stop()
	else:
		animationPlayer.speed_scale = int(Input.is_action_pressed("entity_run")) + 1
	
	motiveHunger -= (world.timeManager.ingameTimestamp - world.timeManager.oldIngameTimestamp) / (Utils.timeUnitsToSeconds(Utils.TimeUnit.Day, 55) * (2 if state == Utils.State.Sleeping else 1))
	motiveThirst -= (world.timeManager.ingameTimestamp - world.timeManager.oldIngameTimestamp) / (Utils.timeUnitsToSeconds(Utils.TimeUnit.Day, 3) * (2 if state == Utils.State.Sleeping else 1))
	motiveEnergy -= (world.timeManager.ingameTimestamp - world.timeManager.oldIngameTimestamp) / (Utils.timeUnitsToSeconds(Utils.TimeUnit.Day) * (-0.33 if state == Utils.State.Sleeping else 1))
	
	if state == Utils.State.Dead:
		return
	
	if world.timeManager.ingameDateTimeObject.Hour > 1 and world.timeManager.ingameDateTimeObject.Hour < 7:
		state = Utils.State.Sleeping
	else:
		state = Utils.State.None
