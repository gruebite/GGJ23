
class_name HexLayout extends Reference


static func floordiv(a: int, b: int) -> int:
	var alz := a < 0
	var blz := b < 0
	if ((alz or blz) and not (alz and blz)) and (a % b != 0):
		return a / b - 1
	return a / b


static func from_size_to_spacing(sz: float) -> Vector3:
	# If size is distance to corner vertex.  For flat top
	# W = 2 * size (pointed side), H = sqrt(3) * size
	return Vector3(sz * Hex.SQRT3, sz * 2.0, 0.0)


var size: Vector3
var position: Vector3


func _init(sz: Vector3, pos: Vector3) -> void:
	size = sz
	position = pos


func screen_offset_to_hex(offset: Vector3) -> Vector2:
	# TODO: Not sure why this is necessary.  Might be because centering sprites cross
	# the negative boundary, and these conversions expect the grid to start at the axes.
	offset += size / 2
	var suborigin := offset - position
	var y := int(floor(suborigin.y / size.y))
	# Odd
	var delta := Vector3() if (y & 1) == 0 else Vector3(size.x / 2, 0, 0)
	return Hex.from_offset(((suborigin - delta) / size).floor())


func hex_to_screen_offset(coord: Vector2) -> Vector3:
	var v := Hex.to_offset(coord)
	var delta := Vector3() if (int(v.y) & 1) == 0 else Vector3(size.x / 2, 0, 0)
	return (v * size) + delta + position
