# Hex functions.  Uses vectors to represent different Hex objects:
#
# - Vector2 is a hex, in axial coordinates.  This is used everywhere.
# - Vector2 is a fractional hex, in axial coordinates.
# - Vector3 is a hex, in offset coordinates.
# - Vector3 is a pixel, in screen coordinates.
class_name Hex extends Object

const SEXTANT := PI / 3
const HALF_SEXTANT := PI / 6
const SQRT3 := sqrt(3.0)
const SQRT3_2 := SQRT3 / 2.0;
const SQRT3_3 := SQRT3 / 3.0;

const DIRECTIONS := [
	Vector2(1, 0), Vector2(0, 1), Vector2(-1, 1),
	Vector2(-1, 0), Vector2(0, -1), Vector2(1, -1),
]

const DIAGONALS := [
	Vector2(1, 1), Vector2(-1, 2), Vector2(-2, 1), 
	Vector2(-1, -1), Vector2(1, -2), Vector2(2, -1), 
]

const CORNERS := [
	Vector3(SQRT3_2, 0.5, 0.0),
	Vector3(0.0, 1.0, 0.0),
	Vector3(-SQRT3_2, -0.5, 0.0),
	Vector3(-SQRT3_2, -0.5, 0.0),
	Vector3(0.0, -1.0, 0.0),
	Vector3(SQRT3_2, -0.5, 0.0),
]

const ANGLES := [
	SEXTANT * 0,
	SEXTANT * 1,
	SEXTANT * 2,
	SEXTANT * 3,
	SEXTANT * 4,
	SEXTANT * 5,
]

enum Direction {
	E,
	SE,
	SW,
	W,
	NW,
	NE,
}

enum Diagonal {
	SE,
	S,
	SW,
	NW,
	N,
	NE,
}

static func origin() -> Vector2: return Vector2.ZERO

static func direction(d: int) -> Vector2: return DIRECTIONS[(6 + (d % 6)) % 6]
static func east() -> Vector2: return DIRECTIONS[Direction.E]
static func southeast() -> Vector2: return DIRECTIONS[Direction.SE]
static func southwest() -> Vector2: return DIRECTIONS[Direction.SW]
static func west() -> Vector2: return DIRECTIONS[Direction.W]
static func northwest() -> Vector2: return DIRECTIONS[Direction.NW]
static func northeast() -> Vector2: return DIRECTIONS[Direction.NE]

static func diagonal(d: int) -> Vector2: return DIAGONALS[(6 + (d % 6)) % 6]
static func diagonal_southeast() -> Vector2: return DIAGONALS[Diagonal.SE]
static func diagonal_south() -> Vector2: return DIAGONALS[Diagonal.S]
static func diagonal_southwest() -> Vector2: return DIAGONALS[Diagonal.SW]
static func diagonal_northwest() -> Vector2: return DIAGONALS[Diagonal.NW]
static func diagonal_north() -> Vector2: return DIAGONALS[Diagonal.N]
static func diagonal_northeast() -> Vector2: return DIAGONALS[Diagonal.NE]

static func corner(d: int) -> Vector3: return CORNERS[(6 + (d % 6)) % 6]
static func corner_east() -> Vector2: return CORNERS[Diagonal.E]
static func corner_southeast() -> Vector2: return CORNERS[Diagonal.SE]
static func corner_southwest() -> Vector2: return CORNERS[Diagonal.SW]
static func corner_west() -> Vector2: return CORNERS[Diagonal.W]
static func corner_northwest() -> Vector2: return CORNERS[Diagonal.NW]
static func corner_northeast() -> Vector2: return CORNERS[Diagonal.NE]


static func angle_to_direction(angle: float) -> int: return angle_to_ring_index(angle, 1)
static func direction_to_angle(d: int) -> float: return ANGLES[(6 + (d % 6)) % 6]
static func angle_to_ring_index(angle: float, radius: int) -> int:
	var half := (HALF_SEXTANT / 2.0) if (radius & 1) == 1 else 0.0
	return normalize_ring_index(int(floor(((angle + half) * radius * 6) / TAU)), radius)
static func normalize_ring_index(index: int, radius: int) -> int:
	var r := radius * 6
	return ((index % r) + r) % r
static func from_offset_to_pixel(offset: Vector3) -> Vector3:
	var x := SQRT3 * (int(offset.x) + 0.5 * (int(offset.y) & 1))
	var y := 3.0 / 2.0 * offset.y
	return Vector3(x, y, 0)


static func from_fractional(fcoord: Vector2) -> Vector2:
	var q := int(round(fcoord.x))
	var r := int(round(fcoord.y))
	var s := int(round(-fcoord.x - fcoord.y))
	var q_diff := abs(q - fcoord.x)
	var r_diff := abs(r - fcoord.y)
	var s_diff := abs(s - (-fcoord.x - fcoord.y))
	if q_diff > r_diff and q_diff > s_diff:
		q = -r - s
	elif r_diff > s_diff:
		r = -q - s
	else:
		s = -q - r
	return Vector2(q, r)
static func from_offset(offset: Vector3) -> Vector2:
	return Vector2(offset.x - (int(offset.y) >> 1), offset.y)
static func from_pixel(pixel: Vector3) -> Vector2:
	return from_fractional(__xyq * int(pixel.x) + __xyr * int(pixel.y))
static func from_angle(angle: float, radius: int = 1) -> Vector2:
	return from_ring_index(angle_to_ring_index(angle, radius), radius)
static func from_ring_index(index: int, radius: int) -> Vector2:
	if radius == 0: return Vector2.ZERO
	if radius < 0:
		radius = -radius
	var sextant := index / radius
	index %= radius
	match sextant:
		0: return Vector2(radius - index, index)
		1: return Vector2(-index, radius)
		2: return Vector2(-radius, radius - index)
		3: return Vector2(index - radius, -index)
		4: return Vector2(index, -radius)
		_: return Vector2(radius, index - radius)
static func from_mod_index(mod: int, radius: int) -> Vector2:
	var shift := 3 * radius + 2
	var ms := int(floor((mod + radius) / shift))
	var mcs := int(floor((mod + (radius << 1)) / (shift - 1)))
	var q := ms * (radius + 1) + mcs * -radius
	var r := mod + ms * (-2 * radius - 1) + mcs * (-radius - 1)
	return Vector2(q, r)


static func to_fractional(coord: Vector2) -> Vector2: return Vector2(coord.x, coord.y)
static func to_offset(coord: Vector2) -> Vector3: return Vector3(coord.x + (int(coord.y) >> 1), coord.y, 0)
static func to_pixel(coord: Vector2) -> Vector3:
	return coord.x*__qxy + coord.y*__rxy
static func to_angle(coord: Vector2) -> float:
	var v := to_pixel(coord)
	return atan2(v.y, v.x)
static func to_mod_index(coord: Vector2, radius: int) -> int:
	var area := 3 * radius * radius + 3 * radius + 1
	var shift := 3 * radius + 2
	var res := int(coord.y + shift * coord.x)
	return ((res % area) + area) % area
static func to_ring_index(coord: Vector2) -> int:
	if coord.x == coord.y: return 0
	if coord.x > 0 and coord.y <= 0: return int(coord.y)
	if coord.x <= 0 and coord.y > 0:
		return int(coord.y - coord.x if (-coord.x < coord.y) else -3 * coord.x - coord.y)
	if coord.x < 0: return int(-4 * (coord.x + coord.y) + coord.x)
	return int(-4 * coord.y + coord.x if (-coord.y > coord.x) else 6 * coord.x + coord.y)
static func to_big(coord: Vector2, radius: int) -> Vector2:
	var area := 3.0 * radius * radius + 3 * radius + 1
	var shift := 3.0 * radius + 2.0
	var coord_s := -coord.x - coord.y
	var qh := int(floor((coord.y + shift * coord.x) / area))
	var rh := int(floor((coord_s + shift * coord.y) / area))
	var sh := int(floor((coord.x + shift * coord_s) / area))
	var x := int(floor((1 + qh - rh) / 3.0))
	var y := int(floor((1 + rh - sh) / 3.0))
	return Vector2(x, y)
static func to_big_local(coord: Vector2, radius: int) -> Vector2:
	return coord - to_small_center(to_big(coord, radius), radius)
static func to_small_center(coord: Vector2, radius: int) -> Vector2:
	var coord_s := -coord.x - coord.y
	return Vector2(
		(radius + 1) * coord.x - radius * coord_s,
		(radius + 1) * coord.y - radius * coord.x)
static func to_color(coord: Vector2) -> int:
	var x := int(coord.x - coord.y)
	return ((x % 3) + 3) % 3

static func get_length(coord: Vector2) -> int:
	var s := -coord.x - coord.y
	return int(abs(coord.x) + abs(coord.y) + abs(s)) / 2

static func get_euclidean_length(coord: Vector2) -> float:
	return sqrt((coord.x*coord.x) + (coord.y*coord.y) + (coord.x*coord.y))

static func get_distance(coord: Vector2, to: Vector2) -> int:
	return get_length(coord - to)

static func get_euclidean_distance(coord: Vector2, to: Vector2) -> float:
	return get_euclidean_length(coord - to)

static func get_ring_neighbor(coord: Vector2, ccw: bool = false) -> Vector2:
	if coord.x > 0:
		if coord.y < 0:
			if coord.x > -coord.y: return coord + DIRECTIONS[4 if ccw else 1]
			if coord.x < -coord.y: return coord + DIRECTIONS[3 if ccw else 0]
			return coord + DIRECTIONS[3 if ccw else 1]
		if coord.y > 0: return coord + DIRECTIONS[5 if ccw else 2]
		return coord + DIRECTIONS[4 if ccw else 2]
	if coord.x < 0:
		if coord.y > 0:
			if coord.y > -coord.x: return coord + DIRECTIONS[0 if ccw else 3]
			if coord.y < -coord.x: return coord + DIRECTIONS[1 if ccw else 4]
			return coord + DIRECTIONS[0 if ccw else 4]
		if coord.y < 0: return coord + DIRECTIONS[2 if ccw else 5]
		return coord + DIRECTIONS[1 if ccw else 5]
	if coord.y > 0: return coord + DIRECTIONS[5 if ccw else 3]
	if coord.y < 0: return coord + DIRECTIONS[2 if ccw else 0]
	return coord

static func get_neighbor(coord: Vector2, dir: int) -> Vector2:
	return coord + direction(dir)

static func rotate_left(coord: Vector2) -> Vector2: return Vector2(-(-coord.x - coord.y), -coord.x)
static func rotate_right(coord: Vector2) -> Vector2: return Vector2(-coord.y, -(-coord.x - coord.y))
static func reflect_q(coord: Vector2) -> Vector2: return Vector2(coord.x, -coord.x - coord.y)
static func reflect_r(coord: Vector2) -> Vector2: return Vector2(-coord.x - coord.y, coord.y)
static func reflect_s(coord: Vector2) -> Vector2: return Vector2(coord.y, coord.x)

static func line(coord: Vector2, to: Vector2) -> Array:
	var c_nudge := to_fractional(coord) + Vector2(1e-6, 1e-6)
	var t_nudge := to_fractional(to) + Vector2(1e-6, 1e-6)
	var n := get_distance(coord, to)
	var step := 1.0 / max(n, 1.0)
	var result: Array = []
	for i in n + 1:
		result.push_back(from_fractional(c_nudge.linear_interpolate(t_nudge, step * i)))
	return result


const __qxy := Vector3(SQRT3, 0.0, 0.0)
const __rxy := Vector3(SQRT3_2, 3.0 / 2.0, 0.0)
const __xyq := Vector2(SQRT3_3, 0.0)
const __xyr := Vector2(-1.0 / 3.0, 2.0 / 3.0)
