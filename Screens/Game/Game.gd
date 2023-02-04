class_name Game extends Node2D

func _ready() -> void:
	var tm := $Grids/Terrain as TileMap
	tm.modulate = Color.whitesmoke
	for coord in GLOBAL.board_hex_set.array:
		var offset := Hex.to_offset(coord)
		tm.set_cell(offset.x, offset.y, 1)


func _process(delta: float) -> void:
	var hl := $Grids/Highlight as TileMap
	hl.clear()
	
	var mouse_pos = get_global_mouse_position() - $Grids.global_position
	var mouse_hex := GLOBAL.pixel_hex_layout.pixel_to_hex(Vector3(mouse_pos.x, mouse_pos.y, 0))
	if GLOBAL.board_hex_set.has(mouse_hex):
		var offset := Hex.to_offset(mouse_hex)
		hl.set_cell(offset.x, offset.y, 2)
