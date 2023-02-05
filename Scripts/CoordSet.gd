class_name CoordSet extends Reference

var array: Array

var size: int setget , get_size
func get_size() -> int: return array.size()


func _init(arr: Array = []) -> void:
	if arr.size() == 0:
		array = arr
		return

	array = []
	for elem in arr:
		add(elem as Vector2)


func size() -> int:
	return array.size()


func clear() -> void:
	array.clear()


func has(coord: Vector2) -> bool:
	var idx := array.bsearch(coord)
	return idx < array.size() and array[idx] == coord


func add(coord: Vector2) -> void:
	var idx := array.bsearch(coord)
	if idx >= array.size():
		array.append(coord)
	elif array[idx] != coord:
		array.insert(idx, coord)

func remove(coord: Vector2) -> void:
	var idx := array.bsearch(coord)
	if idx < array.size() and array[idx] == coord:
		array.remove(idx)


func get_random(rand: Random) -> Vector2:
	return rand.choice(array)
