class_name World extends Node2D

@onready var timeManager: TimeManager = $TimeManager
@onready var objects: TileMapLayer = $Objects
@onready var light: PointLight2D = $Light

func _ready() -> void:
	for i in 2:
		var local := Utils.LocalScene.instantiate()
		local.sex = i
		local.global_position = objects.map_to_local(Vector2(randi_range(-5, 5), randi_range(-5, 5)))
		add_child(local)
		
		var animal := Utils.AnimalScene.instantiate()
		animal.sex = i
		animal.global_position = objects.map_to_local(Vector2(randi_range(-5, 5), randi_range(-5, 5)))
		add_child(animal)

func _physics_process(_delta: float) -> void:
	if timeManager.timeScale < 1:
		return
	
	light.energy = -0.44 * (cos((timeManager.secondsIntoDay / 86400.0) * (PI * 2)) / (1 if Utils.AMOUNT_OF_SECONDS_PER_TIME_UNIT.find(int(timeManager.timeScale)) < 5 else 10)) + 0.56
