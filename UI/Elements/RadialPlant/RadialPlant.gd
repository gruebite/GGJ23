extends Control

signal plant_selected(plant_type)

var saved_plant_cards := []

func set_plant_options(plant_cards: Array, scores: Array) -> void:
	saved_plant_cards = plant_cards.duplicate()
	for i in range(3):
		var top_node := get_child(i)
		var texture_node := top_node.get_node("PlantTexture")
		texture_node.texture = MODEL.plants[saved_plant_cards[i].type].texture
		top_node.get_node("Score").text = str(scores[i])


func _on_radial_input(event: InputEvent, radial_index: int) -> void:
	if event is InputEventMouseButton:
		if event.pressed:
			emit_signal("plant_selected", saved_plant_cards[radial_index])
