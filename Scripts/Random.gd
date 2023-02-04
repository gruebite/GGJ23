class_name Random extends Object

var rng: RandomNumberGenerator


func _init(r: RandomNumberGenerator = null) -> void:
	if r:
		rng = r
	else:
		rng = RandomNumberGenerator.new()
		rng.randomize()


func gaussian(mean: float = 0.0, deviation: float = 1.0) -> float:
	return rng.randfn(mean, deviation)


func f() -> float:
	return rng.randf()


func rangef(a: float, b: float) -> float:
	return rng.rand_range(a, b)


func i() -> int:
	return rng.randi()


func rangei(a: int, b: int) -> int:
	return rng.randi_range(a, b)


func d(n: int, s: int = 1) -> int:
	var sum := 0
	for _i in s:
		sum += rangei(1, n)
	return sum


func choice(arr: Array):
	return arr[rangei(0, arr.size() - 1)]
