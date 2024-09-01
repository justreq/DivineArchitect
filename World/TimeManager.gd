class_name TimeManager extends Node

var currentTick := 0

var timeScale := 0.0
var ingameTimestamp := 0.0
var ingameDateTimeObject: Dictionary:
	get:
		var modValues := [60, 60, 24, 7, 4, 12, 1]
		var object := {}
		var seconds := roundi(ingameTimestamp)
		
		for i in modValues.size():
			object[Utils.TimeUnit.keys()[i]] = seconds % modValues[i] if modValues[i] != 1 else seconds
			seconds /= modValues[i]
		
		return object

var secondsIntoDay: int:
	get:
		return ingameDateTimeObject.Hour * 60 * 60 + ingameDateTimeObject.Minute * 60 + ingameDateTimeObject.Second

var daysIntoMonth: int:
	get:
		return ingameDateTimeObject.Week * 7 + ingameDateTimeObject.Day

func _physics_process(_delta: float) -> void:
	if timeScale == 0:
		return
	
	currentTick += 1
	
	if currentTick >= 60 / timeScale:
		ingameTimestamp += currentTick * timeScale / 60
		currentTick = 0
