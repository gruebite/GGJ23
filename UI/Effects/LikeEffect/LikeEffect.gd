extends Sprite

const LIKE_DISLIKE_TEXTURES := [
	preload("res://Assets/Textures/Dislike.png"),
	preload("res://Assets/Textures/Like.png"),
]

var like := true
var lifetime := 1.0
var speed := 20.0

func set_like(to: bool) -> void:
	like = to
	texture = LIKE_DISLIKE_TEXTURES[int(like)]

func _process(delta: float) -> void:
	lifetime -= delta
	position.y -= speed * delta
	modulate.a = lerp(1.0, 0.5, 1.0 - lifetime)
	
	if lifetime <= 0.0:
		queue_free()
