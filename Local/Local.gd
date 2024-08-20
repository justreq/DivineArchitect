class_name Local extends CharacterBody2D

enum Sex {
	Male,
	Female
}

enum Title {
	Nomad
}

enum State {
	None,
	Sleeping,
	Eating,
	Drinking
}

@export var world: World

@export var sex := Sex.Male
@export var title := Title.Nomad
@export var state := State.None
@export var firstName := "Adam"
@export var lastName := ""

@onready var sprite: Sprite2D = $Sprite2D
@onready var navigationAgent: NavigationAgent2D = $NavigationAgent2D
@onready var grabbedItem: Node2D = $GrabbedItem

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

var speed := 50
var direction := Vector2.ZERO
var heldItem: Item = null

func die(cause: String):
	print(firstName + " " + lastName + " died of " + cause + " at " + str(int((world.ingameTimestamp - birthTimestamp) / 86400)) + " days old")
	queue_free()

func sleep():
	sleeping = true

var lookingForAPlaceToEat := false

func stateLookForFood():
	if is_instance_valid(heldItem) and heldItem.is_in_group("Food"):
		if lookingForAPlaceToEat:
			navigationAgent.target_position = Vector2(global_position.x + 50 * cos(randf_range(0, PI * 2)), global_position.y + 50 * sin(randf_range(0, PI * 2)))
			lookingForAPlaceToEat = false
		elif navigationAgent.target_reached:
			stateEatFood()
	else:
		var food := get_tree().get_nodes_in_group("Food").filter(func(e): return e.grabbable and e.dropped)
		food.sort_custom(func(e1: Node, e2: Node): return e1.global_position.distance_to(global_position) < e2.global_position.distance_to(global_position))

		if food:
			navigationAgent.target_position = food[0].global_position
			
			if navigationAgent.target_reached:
				lookingForAPlaceToEat = true
		else:
			var animals := get_tree().get_nodes_in_group("Animal")
			animals.sort_custom(func(e1: Node, e2: Node): return e1.global_position.distance_to(global_position) < e2.global_position.distance_to(global_position))
			
			if animals:
				navigationAgent.target_position = animals[0].global_position

var timeStartedEatingFood := 0

func stateEatFood():
	state = State.Eating
	
	if timeStartedEatingFood == 0:
		timeStartedEatingFood = world.ingameTimestamp
		
	if world.ingameTimestamp - timeStartedEatingFood <= 4:
		heldItem.position.y = sin((world.ingameTimestamp - timeStartedEatingFood) * 1000 * (PI * 2 / 240))
	else:
		timeStartedEatingFood = 0
		heldItem.queue_free()
		heldItem = null
		state = State.None

func _ready() -> void:
	birthTimestamp = world.ingameTimestamp
	oldIngameTimestamp = birthTimestamp
	motiveHunger = 0.8
	
	if sex == Sex.Female:
		sprite.region_rect = Rect2(16, 0, 16, 32)

func _process(_delta: float) -> void:
	direction = (navigationAgent.get_next_path_position() - global_position).normalized()
	velocity = direction * speed
	move_and_slide()
	
	oldIngameTimestamp = world.ingameTimestamp
	
	motiveHunger += (world.ingameTimestamp - oldIngameTimestamp) / (86400 * (7 + (63 * (1 - motiveThirst))) * (2 if sleeping else 1))
	if motiveHunger >= 1:
		die("starvation")
	elif moodletHunger == "Hungry":
			stateLookForFood()
	
	motiveThirst = 0.99
	#motiveThirst += (world.ingameTimestamp - oldIngameTimestamp) / (86400 * 3 * (2 if sleeping else 1))
	if motiveThirst >= 1:
		die("dehydration")
	
	motiveEnergy = 0
	#motiveEnergy += ((world.ingameTimestamp - oldIngameTimestamp) * (-1 if sleeping else 1) / (86400))
	if motiveEnergy >= 1:
		sleep()
	
	if sleeping and motiveEnergy == 0:
		sleeping = false
	
	hungerBar.value = motiveHunger
	hungerMoodletLabel.text = str(moodletHunger)
	thirstBar.value = motiveThirst
	thirstMoodletLabel.text = str(moodletThirst)
	energyBar.value = motiveEnergy
	energyMoodletLabel.text = str(moodletEnergy)

func _on_interaction_range_area_entered(area: Area2D) -> void:
	if area.get_parent() is Item and not heldItem:
		var item = area
		if not item.grabbable:
			return
			
		item.grabbable = false
		item.linear_velocity = item.grabArea.global_position.direction_to(area.global_position) * 50

func _on_grab_point_area_entered(area: Area2D) -> void:
	if area.get_parent() is Item and not heldItem:
		var item = area.get_parent()
		
		heldItem = item
		item.get_parent().remove_child(item)
		grabbedItem.call_deferred("add_child", item)
		item.grabbable = false
		item.dropped = false

func _on_grabbed_item(node: Node) -> void:
	node.global_position = grabbedItem.global_position
