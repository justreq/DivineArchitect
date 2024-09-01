extends Node

const LocalScene = preload("res://Local/Local.tscn")
const AnimalScene = preload("res://Animals/Animal.tscn")

enum TimeUnit { Second, Minute, Hour, Day, Week, Month, Year }
enum Day { Monday, Tuesday, Wednesday, Thursday, Friday, Saturday, Sunday }
enum Month { January, February, March, April, May, June, July, August, September, October, November, December }

const AMOUNT_OF_SECONDS_PER_TIME_UNIT := [0, 1, 60, 3600, 86400, 604800, 2419200, 29030400]
# 0 is placed to allow freezing time by reading the time scale slider value

enum Area { Forest }

enum Sex { Male, Female }

enum AnimalType { Ox }
enum TreeFrame { Sprout, Sapling, Adult, Stump }

enum LocalState { None, Wandering, Sleeping, LookingForFood, Eating, LookingForWater, Drinking }
enum HungerMoodlet { Hungry, VeryHungry, Starving }
enum ThirstMoodlet { Thirsty, VeryThirsty, Parched }
enum EnergyMoodlet { WellRested, Sleepy, Tired, Exhausted }
