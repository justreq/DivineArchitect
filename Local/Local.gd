extends CharacterBody2D

enum Sex {
	Male,
	Female
}

@export var world: World

@export var sex := Sex.Male
@export var firstName := "Adam"
@export var lastName := ""

@onready var sprite: Sprite2D = $Sprite2D

@onready var hungerBar: ProgressBar = $PanelContainer/VBoxContainer/HBoxContainer1/HungerBar
@onready var hungerMoodletLabel: Label = $PanelContainer/VBoxContainer/HBoxContainer1/HungerMoodletLabel
@onready var thirstBar: ProgressBar = $PanelContainer/VBoxContainer/HBoxContainer2/ThirstBar
@onready var thirstMoodletLabel: Label = $PanelContainer/VBoxContainer/HBoxContainer2/ThirstMoodletLabel
@onready var energyBar: ProgressBar = $PanelContainer/VBoxContainer/HBoxContainer3/EnergyBar
@onready var energyMoodletLabel: Label = $PanelContainer/VBoxContainer/HBoxContainer3/EnergyMoodletLabel

enum MoodletHunger {
	Fed,
	Hungry,
	Starving,
}
@export var motiveHunger := 0.0
@export var moodletHunger := MoodletHunger.Fed

enum MoodletThirst {
	Hydrated,
	Thirsty,
	Parched,
}
@export var motiveThirst := 0.0
@export var moodletThirst := MoodletThirst.Hydrated

enum MoodletEnergy {
	Energetic,
	Tired,
	Exhausted,
	Sleeping
}
@export var motiveEnergy := 0.0
@export var moodletEnergy := MoodletEnergy.Energetic

var birthTimestamp: int
var oldIngameTimestamp := 0.0
var sleeping := false

func die(cause: String):
	print(firstName + " " + lastName + " died of " + cause + " at " + str(int((world.ingameTimestamp - birthTimestamp) / 86400)) + " days old")
	queue_free()

func sleep():
	sleeping = true

func _ready() -> void:
	birthTimestamp = world.ingameTimestamp
	oldIngameTimestamp = birthTimestamp
	
	if sex == Sex.Female:
		sprite.region_rect = Rect2(16, 0, 16, 32)

func _process(_delta: float) -> void:
	if int(oldIngameTimestamp) != int(world.ingameTimestamp):
		motiveHunger += (world.ingameTimestamp - oldIngameTimestamp) / (86400 * (7 + (63 if moodletThirst == MoodletThirst.Hydrated else 0)) * (2 if sleeping else 1))
		moodletHunger = MoodletHunger.Fed if motiveHunger < 0.33 else MoodletHunger.Starving if motiveHunger > 0.67 else MoodletHunger.Hungry
		if motiveHunger >= 1:
			die("starvation")
		
		motiveThirst += (world.ingameTimestamp - oldIngameTimestamp) / (86400 * 3 * (2 if sleeping else 1))
		moodletThirst = MoodletThirst.Hydrated if motiveThirst < 0.33 else MoodletThirst.Parched if motiveThirst > 0.67 else MoodletThirst.Thirsty
		if motiveThirst >= 1:
			die("dehydration")
	
		motiveEnergy += ((world.ingameTimestamp - oldIngameTimestamp) * (-1 if sleeping else 1) / (86400))
		moodletEnergy = MoodletEnergy.Sleeping if sleeping else MoodletEnergy.Energetic if motiveEnergy < 0.33 else MoodletEnergy.Exhausted if motiveEnergy > 0.67 else MoodletEnergy.Tired
		if motiveEnergy >= 1:
			sleep()
		
		if sleeping and motiveEnergy <= 0.05:
			sleeping = false
	
	oldIngameTimestamp = world.ingameTimestamp
	
	hungerBar.value = motiveHunger
	hungerMoodletLabel.text = str(MoodletHunger.keys()[moodletHunger])
	thirstBar.value = motiveThirst
	thirstMoodletLabel.text = str(MoodletThirst.keys()[moodletThirst])
	energyBar.value = motiveEnergy
	energyMoodletLabel.text = str(MoodletEnergy.keys()[moodletEnergy])
