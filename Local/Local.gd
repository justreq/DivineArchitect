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

var moodletHunger := ""
var motiveHunger := 0.0:
	get:
		return motiveHunger
	set(value):
		motiveHunger = value
		
		if value >= 0.95:
			moodletHunger = "Starving"
		elif value >= 0.9:
			moodletHunger = "Very Hungry"
		elif value >= 0.8:
			moodletHunger = "Hungry"
		else:
			moodletHunger = ""

var moodletThirst := ""
var motiveThirst := 0.0:
	get:
		return motiveThirst
	set(value):
		motiveThirst = value
		
		if value >= 0.95:
			moodletThirst = "Parched"
		elif value >= 0.9:
			moodletThirst = "Very Thirsty"
		elif value >= 0.8:
			moodletThirst = "Thirsty"
		else:
			moodletThirst = ""

var moodletEnergy := ""
var motiveEnergy := 0.0:
	get:
		return motiveEnergy
	set(value):
		motiveEnergy = value
		
		if value == 1:
			moodletEnergy = "Exhausted"
		elif value >= 0.95:
			moodletEnergy = "Tired"
		elif value >= 0.9:
			moodletEnergy = "Sleepy"
		elif value <= 1.0:
			moodletEnergy = "Well Rested"
		else:
			moodletEnergy = ""

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
		motiveHunger += (world.ingameTimestamp - oldIngameTimestamp) / (86400 * (7 + (63 if moodletThirst == "" else 0)) * (2 if sleeping else 1))
		if motiveHunger >= 1:
			die("starvation")
		
		motiveThirst += (world.ingameTimestamp - oldIngameTimestamp) / (86400 * 3 * (2 if sleeping else 1))
		if motiveThirst >= 1:
			die("dehydration")
	
		motiveEnergy += ((world.ingameTimestamp - oldIngameTimestamp) * (-1 if sleeping else 1) / (86400))
		if motiveEnergy >= 1:
			sleep()
		
		if sleeping and motiveEnergy == 0:
			sleeping = false
	
	oldIngameTimestamp = world.ingameTimestamp
	
	hungerBar.value = motiveHunger
	hungerMoodletLabel.text = str(moodletHunger)
	thirstBar.value = motiveThirst
	thirstMoodletLabel.text = str(moodletThirst)
	energyBar.value = motiveEnergy
	energyMoodletLabel.text = str(moodletEnergy)
