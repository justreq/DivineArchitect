class_name World extends Node2D

@onready var worldCamera := $WorldCamera
@onready var timeManager: TimeManager = $TimeManager
@onready var objects := $Objects
@onready var light := $Light

@onready var localInfoInterface: Control = $CanvasLayer/LocalInfoInterface

func _init() -> void:
	Main.currentWorld = self

func _ready() -> void:
	timeManager.ingameTimestamp += Utils.timeUnitsToSeconds(Utils.TimeUnit.Day) / 2 # Skip to midday so I can see better

func _physics_process(_delta: float) -> void:
	if timeManager.timeScale == 0:
		return
	
	light.energy = -0.44 * (cos((timeManager.secondsIntoDay / float(Utils.timeUnitsToSeconds(Utils.TimeUnit.Day))) * (PI * 2)) / (1 if Utils.TIME_SCALE_VALUES.find(int(timeManager.timeScale)) < 5 else 10)) + 0.56
