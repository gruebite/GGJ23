class_name PlantCard extends Card

var type: int
var def: Dictionary

func _init(plant_type: int) -> void:
	type = plant_type
	def = MODEL.plants[plant_type]


func display_texture() -> Texture:
	return def.texture


func display_name() -> String:
	return def.name


func likes_list() -> Array:
	return def.likes.keys()


func likes(plant_type: int) -> bool:
	return def.likes.has(plant_type)


func dislikes_list() -> Array:
	return def.dislikes.keys()


func dislikes(plant_type: int) -> bool:
	return def.dislikes.has(plant_type)
