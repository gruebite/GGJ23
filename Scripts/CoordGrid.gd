class_name CoordGrid extends Reference

var cells := {}


func count_cells() -> int:
	return cells.size()


func clear_cells() -> void:
	cells.clear()


func has_cell(coord: Vector2) -> bool:
	return cells.has(coord)


func set_cell(coord: Vector2, value) -> void:
	cells[coord] = value


func get_cell(coord: Vector2, default = null):
	if cells.has(coord):
		return cells[coord]
	return default


func clear_cell(coord: Vector2) -> void:
	cells.erase(coord)
