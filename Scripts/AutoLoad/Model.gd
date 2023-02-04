class_name Model extends Node


enum Plant {
	ALL = -1,
	YGGDRASIL,
	MIGHTY_OAK,
}

var plants := [
	{
		"name": "Yggdrasil",
		"likes": {Plant.ALL: true},
		"dislikes": {},
	},
	{
		"name": "Mighty Oak",
		"likes": {},
		"dislikes": {Plant.MIGHTY_OAK: true},
	},
]

var plant_synergies := []
var plant_antogonies := []

func _ready() -> void:
	pass
