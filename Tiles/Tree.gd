extends StaticBody2D

@onready var ageManager: AgeManager = $AgeManager
@onready var sprite := $Sprite

func _ready() -> void:
	ageManager.lifespanSeconds = Utils.timeUnitsToSeconds(Utils.TimeUnit.Year, 125)

func _physics_process(delta: float) -> void:
	if sprite.frame < 3:
		sprite.frame = floori(ageManager.age / float(Utils.timeUnitsToSeconds(Utils.TimeUnit.Year, 40)) * 3)
