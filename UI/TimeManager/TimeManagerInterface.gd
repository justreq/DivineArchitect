extends Control

@export var timeManager: TimeManager

@onready var dateTimeLabel: Label = %DateTimePanel/DateTimeLabel
@onready var clockHandMinute: Sprite2D = %Clock/ClockHandMinute
@onready var clockHandHour: Sprite2D = %Clock/ClockHandHour
@onready var timeScaleSlider: HSlider = $VBoxContainer/PanelContainer/MarginContainer/TimeSpeedPanel/TimeScaleSlider

@onready var timeSpeedLabel: Label = %TimeSpeedPanel/TimeSpeedLabel

func setTimeScale(value: float) -> void:
	timeManager.timeScale = Utils.TIME_SCALE_VALUES[value]
	setTimeScaleLabel(value)

func setTimeScaleLabel(value: float) -> void:
	timeSpeedLabel.text = "Time Frozen" if value == 0 else ("Time Scale: 1 " + Utils.TimeUnit.keys()[int(value - 1)].to_lower() + " / second")

func _ready() -> void:
	setTimeScale(1)

func _physics_process(_delta: float) -> void:
	dateTimeLabel.text = Utils.Month.keys()[timeManager.ingameDateTimeObject.Month].left(3) + " " + str(timeManager.daysIntoMonth + 1) + (["st", "nd", "rd"][int(str(timeManager.daysIntoMonth)[-1])] if not (timeManager.daysIntoMonth > 3  and timeManager.daysIntoMonth < 20) and int(str(timeManager.daysIntoMonth + 1)[-1]) in [1, 2, 3] else "th") + ", Year " + str(timeManager.ingameDateTimeObject.Year) + "\n" + ("0" if timeManager.ingameDateTimeObject.Hour < 10 else "") + str(timeManager.ingameDateTimeObject.Hour) + ":" + ("0" if timeManager.ingameDateTimeObject.Minute < 10 else "") + str(timeManager.ingameDateTimeObject.Minute) + ":" + ("0" if timeManager.ingameDateTimeObject.Second < 10 else "") + str(timeManager.ingameDateTimeObject.Second)
	clockHandMinute.rotation = timeManager.ingameDateTimeObject.Minute * PI * 2 / 60
	clockHandHour.rotation = (timeManager.ingameDateTimeObject.Hour * PI * 2 / 12) + clockHandMinute.rotation / 12

func onTimeScaleSliderDragEnded(_value_changed: bool) -> void:
	setTimeScale(timeScaleSlider.value)

func onTimeScaleSliderValueChanged(value: float) -> void:
	setTimeScaleLabel(value)
