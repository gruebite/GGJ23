class_name PlantCard extends Card

var type: int
var def: Dictionary

func _init(plant_type: int) -> void:
	type = plant_type
	def = MODEL.plants[plant_type]


func display_name() -> String:
	return def.name


func likes(plant_type: int) -> bool:
	return def.likes.has(plant_type)


func dislikes(plant_type: int) -> bool:
	return def.dislikes.has(plant_type)
