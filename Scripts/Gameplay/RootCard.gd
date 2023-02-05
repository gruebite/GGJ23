class_name RootCard extends Card


var type: int
var layout: CoordSet


func _init(card_type: int) -> void:
	type = card_type
	layout = MODEL.root_layouts[type]
