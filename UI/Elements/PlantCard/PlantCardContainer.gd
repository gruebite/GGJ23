extends CardContainer

signal selected()

onready var name_label := $Container/Overview/Name
onready var icon := $Container/Overview/CenterContainer/Icon

onready var likes := $Container/Synergies/Likes
onready var dislikes := $Container/Synergies/Dislikes


func _ready() -> void:
	set_plant_card(PlantCard.new(Model.Plant.MIGHTY_OAK))


func _on_button_pressed() -> void:
	emit_signal("selected")


func set_plant_card(card: PlantCard) -> void:
	name_label.text = card.display_name()
	icon.texture = card.display_texture()
	
	var likes_keys := card.likes_list()
	var dislikes_keys := card.dislikes_list()
	for i in range(5):
		var likes_child := likes.get_child(i)
		if i < likes_keys.size():
			likes_child.texture = MODEL.plants[likes_keys[i]].texture
			likes_child.show()
		else:
			likes_child.texture = null
			likes_child.hide()

		var dislikes_child := dislikes.get_child(i)
		if i < dislikes_keys.size():
			dislikes_child.texture = MODEL.plants[dislikes_keys[i]].texture
			dislikes_child.show()
		else:
			dislikes_child.texture = null
			dislikes_child.hide()
	
