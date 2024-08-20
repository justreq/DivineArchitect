class_name World extends Node2D

const TIME_UNIT_SETTINGS := [
	{ "max": 10, "factor": 0.1 },
	{ "max": 60, "factor": 1 },
	{ "max": 60, "factor": 60 },
	{ "max": 24, "factor": 3600 },
	{ "max": 7, "factor": 86400 },
	{ "max": 4, "factor": 604800 },
	{ "max": 12, "factor": 2419200 },
]

@onready var light := $PointLight2D

@onready var timeLabel: Label = $GUI/MarginContainer/TimePanel/VBoxContainer/TimeLabel
@onready var timeSpeedSlider: HSlider = $GUI/MarginContainer/TimePanel/VBoxContainer/HBoxContainer/TimeSpeedSlider
@onready var timeSpeedLabel: Label = $GUI/MarginContainer/TimePanel/VBoxContainer/HBoxContainer/TimeSpeedLabel
@onready var flashWarningLabel: Label = $GUI/FlashWarningLabel

var ingameTimestamp := (float(Time.get_unix_time_from_system() + Time.get_time_zone_from_system().bias))
var currentTimeUnit := 1

func manage_time_and_light_level() -> void:
	if timeSpeedSlider.value == 0:
		return
	
	var IngameTimestamp = ingameTimestamp
	ingameTimestamp += float(timeSpeedSlider.value * TIME_UNIT_SETTINGS[currentTimeUnit].factor / 60)
	timeLabel.text = "Time: " + Time.get_time_string_from_unix_time(ingameTimestamp) + "\n" + Time.get_date_string_from_unix_time(ingameTimestamp)
	light.energy = -0.44 * cos((float(IngameTimestamp) / 86400) * (PI * 2)) + 0.56

func change_time_speed_label() -> void:
	timeSpeedLabel.text = str(timeSpeedSlider.value)
	flashWarningLabel.visible = (currentTimeUnit == 3 and timeSpeedSlider.value == 24) or (currentTimeUnit > 3 and timeSpeedSlider.value != 0)

func _ready() -> void:
	change_time_speed_label()

func _physics_process(_delta: float) -> void:
	manage_time_and_light_level()

func _on_time_speed_slider_value_changed(_value: float) -> void:
	change_time_speed_label()

func _on_time_unit_selected(index: int) -> void:
	timeSpeedSlider.max_value = TIME_UNIT_SETTINGS[index].max
	timeSpeedSlider.tick_count = TIME_UNIT_SETTINGS[index].max + 1
	timeSpeedSlider.value = 1 if index > currentTimeUnit else timeSpeedSlider.max_value - 1
	
	currentTimeUnit = index
	
	change_time_speed_label()

func _input(event: InputEvent) -> void:
	if (event.is_action_pressed("DEBUG_reset")):
		get_tree().reload_current_scene()
