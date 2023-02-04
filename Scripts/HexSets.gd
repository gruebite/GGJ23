class_name HexSets extends Object

static func origin() -> CoordSet: return CoordSet.new([Vector2.ZERO])
static func directions() -> CoordSet: return CoordSet.new(Hex.DIRECTIONS)
static func diagonals() -> CoordSet: return CoordSet.new(Hex.DIAGONALS)
static func parallelogram_r(q1: int, q2: int, r1: int, r2: int) -> CoordSet:
	var hset := CoordSet.new()
	var q := q1
	while q <= q2:
		var r := r1
		while r <= r2:
			hset.add(Vector2(q, r))
			r += 1
		q += 1
	return hset
static func parallelogram_s(s1: int, s2: int, q1: int, q2: int) -> CoordSet:
	var hset := CoordSet.new()
	var s := s1
	while s <= s2:
		var q := q1
		while q <= q2:
			hset.add(Vector2(q, -q - s))
			q += 1
		s += 1
	return hset
static func parallelogram_q(r1: int, r2: int, s1: int, s2: int) -> CoordSet:
	var hset := CoordSet.new()
	var r := r1
	while r <= r2:
		var s := s1
		while s <= s2:
			hset.add(Vector2(-r -s, r))
			s += 1
		r += 1
	return hset
static func triangle_south(sz: int) -> CoordSet:
	var hset := CoordSet.new()
	var q := 0
	while q <= sz:
		var r := 0
		while r <= sz - q:
			hset.add(Vector2(q, r))
			r += 1
		q += 1
	return hset
static func triangle_north(sz: int) -> CoordSet:
	var hset := CoordSet.new()
	var q := 0
	while q <= sz:
		var r := sz - q
		while r <= sz:
			hset.add(Vector2(q, r))
			r += 1
		q += 1
	return hset
static func hexagon(radius: int) -> CoordSet:
	var hset := CoordSet.new()
	var q := -radius
	while q <= radius:
		var r1 := int(max(-radius, -q - radius))
		var r2 := int(min(radius, -q + radius))
		var r := r1
		while r <= r2:
			hset.add(Vector2(q, r))
			r += 1
		q += 1
	return hset
static func ring(radius: int) -> CoordSet:
	if radius == 0: return origin()
	var hset := CoordSet.new()
	var coord := Hex.direction(0) * radius
	for i in 6:
		for j in radius:
			hset.add(coord)
			coord = Hex.get_neighbor(coord, i + 2)
	return hset
static func rectangle(left: int, right: int, top: int, bottom: int) -> CoordSet:
	var hset := CoordSet.new()
	var r := top
	while r <= bottom:
		var r_offset := r >> 1
		var q := left - r_offset
		while q <= right - r_offset:
			hset.add(Vector2(q, r))
			q += 1
		r += 1
	return hset
