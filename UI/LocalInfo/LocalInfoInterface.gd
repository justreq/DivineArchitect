extends Control

@onready var animationPlayer := $AnimationPlayer

@onready var faithColumn := %FaithColumn
@onready var hungerMotiveColumn := %HungerMotiveColumn
@onready var thirstMotiveColumn := %ThirstMotiveColumn
@onready var energyMotiveColumn := %EnergyMotiveColumn

@export var local: Local:
	set(value):
		var oldValue := local
		local = value
		
		if oldValue != local:
			animationPlayer.play("show" if local else "hide")

func setInfo():
		%NameLabel.text = local.fullName.replacen(" ", "\n") if local else ""
		%SexIcon.texture = Utils.SexIcons[local.sex] if local else null
		%SexIcon.tooltip_text = "Sex: " + Utils.Sex.keys()[local.sex] if local else ""
		%InfoLabel.text = "Age: " + str(Utils.secondsToTimeUnits(local.ageManager.age, Utils.TimeUnit.Year)) + "\nOccupation: " + Utils.LocalOccupation.keys()[local.occupation] if local else ""

func _physics_process(delta: float) -> void:
	if !local:
		return
		
	faithColumn.statLevel = local.faith
	hungerMotiveColumn.statLevel = local.motiveHunger
	thirstMotiveColumn.statLevel = local.motiveThirst
	energyMotiveColumn.statLevel = local.motiveEnergy

func onAnimationStarted(anim_name: StringName) -> void:
	if anim_name == "show":
		setInfo()

func onAnimationFinished(anim_name: StringName) -> void:
	if anim_name == "hide":
		setInfo()
