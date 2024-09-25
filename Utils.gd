extends Node

const SexIcons := [preload("res://UI/LocalInfo/LocalSexIconMale.png"), preload("res://UI/LocalInfo/LocalSexIconFemale.png")]

const LocalScene := preload("res://Local/Local.tscn")
const AnimalScene := preload("res://Animals/Animal.tscn")

const RedYellowGreenGradient = preload("res://Assets/RedYellowGreenGradient.tres")

enum TimeUnit { Second, Minute, Hour, Day, Week, Month, Year }
enum Day { Monday, Tuesday, Wednesday, Thursday, Friday, Saturday, Sunday }
enum Month { January, February, March, April, May, June, July, August, September, October, November, December }

const TIME_SCALE_VALUES := [0, 1, 60, 3600, 86400, 604800, 2419200, 29030400]

func timeUnitsToSeconds(unit: TimeUnit, amount := 1) -> int:
	var value := amount
	
	for i in [1, 60, 60, 24, 7, 4, 12].slice(0, unit + 1):
		value *= i
	
	return value

func secondsToTimeUnits(amount: int, unit: TimeUnit) -> float:
	var value := amount
	
	for i in [1, 60, 60, 24, 7, 4, 12].slice(0, unit + 1):
		value /= i
	
	return value

enum Direction { Up, Left, Down, Right }

func vectorToDirection(direction: Vector2):
	if direction.x == 0:
		return Direction.Up if direction.y == -1 else Direction.Down
	
	return Direction.Left if direction.x < 0 else Direction.Right

enum Area { Forest }

enum Sex { Male, Female }
enum State { None, Dead, Sleeping }

enum AnimalType { Ox }
const ANIMAL_LIFESPANS := [20]

enum TreeFrame { Sprout, Sapling, Adult, Stump }

enum LocalOccupation { None }

enum MoodletHunger { Satiated, Hungry, VeryHungry, Starving }
enum MoodletThirst { Hydrated, Thirsty, VeryThirsty, Parched }
enum MoodletEnergy { WellRested, Sleepy, Tired, Exhausted }
