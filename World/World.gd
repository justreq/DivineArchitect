extends Node2D

@onready var light := $PointLight2D
@onready var timeLabel: Label = $GUI/Label

var daysOld := 0
var timeFrames := 0

func hours_to_frames(hours: int) -> int:
	return hours * 60 * 60

func frames_to_hours(frames: int) -> int:
	return int(frames / 60 / 60)

func frames_to_minutes(frames: int) -> int:
	return int(frames / 60)

func _physics_process(_delta: float) -> void:
	timeFrames += 1
	timeLabel.text = "Time: " + ("0" if frames_to_hours(timeFrames) < 10 else "") + str(frames_to_hours(timeFrames)) + ":" + ("0" if frames_to_minutes(timeFrames) % 60 < 10 else "") + str(frames_to_minutes(timeFrames) % 60)
	light.energy = -0.44 * cos((float(timeFrames) / hours_to_frames(24)) * (2 * PI)) + 0.56
	
	if timeFrames > hours_to_frames(24) - 1:
		timeFrames = 0
