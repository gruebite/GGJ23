extends CardContainer


func _ready() -> void:
	set_root_card(RootCard.new(Model.Root.CrossS))


func set_root_card(root_card: RootCard) -> void:
	for coord in GLOBAL.root_card_coord_set.array:
		var offset := Hex.to_offset(coord)
		$CenterContainer/Control/TileMap.set_cell(offset.x, offset.y, 0)
	$CenterContainer/Control/TileMap.set_cell(0, 0, 1)
	
	for coord in root_card.layout.array:
		var offset := Hex.to_offset(coord)
		$CenterContainer/Control/TileMap.set_cell(offset.x, offset.y, 2)
