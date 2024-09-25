class_name World extends Node2D

@onready var worldCamera := $WorldCamera
@onready var timeManager: TimeManager = $TimeManager
@onready var objects := $Objects
@onready var light := $Light

@onready var localInfoInterface: Control = $CanvasLayer/LocalInfoInterface

func _ready() -> void:
	Main.currentWorld = self
	
	for i in 2:
		var local := Utils.LocalScene.instantiate()
		local.position = objects.map_to_local(Vector2(randi_range(-8, 8), randi_range(-8, 8)))
		local.initialize(self, i, ["Adam", "Eve"][i], Utils.LocalOccupation.None, Color("d2a776"), Color("412918"))
		self.add_child(local)
		
		var animal := Utils.AnimalScene.instantiate()
		animal.position = objects.map_to_local(Vector2(randi_range(-8, 8), randi_range(-8, 8)))
		animal.initialize(self, Utils.AnimalType.Ox, i, ["Adam", "Eve"][i])
		self.add_child(animal)
	
	timeManager.ingameTimestamp += Utils.timeUnitsToSeconds(Utils.TimeUnit.Day) / 2

func _physics_process(_delta: float) -> void:
	if timeManager.timeScale == 0:
		return
	
	light.energy = -0.44 * (cos((timeManager.secondsIntoDay / float(Utils.timeUnitsToSeconds(Utils.TimeUnit.Day))) * (PI * 2)) / (1 if Utils.TIME_SCALE_VALUES.find(int(timeManager.timeScale)) < 5 else 10)) + 0.56
