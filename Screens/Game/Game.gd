class_name Game extends Node2D

enum State {
	SELECT_ROOT_CARD,
	SELECT_PLANT,
	SELECT_ROOT,
	SELECT_PLANT_CARD,
}

var placed_plants := {}
var current_state := State.SELECT_ROOT_CARD as int

var plant_deck := []
var root_deck := []

var roots_coord_set := CoordSet.new()
var root_selected := Vector2.ZERO

func _ready() -> void:
	var tm := $Grids/Terrain as TileMap
	tm.modulate = Color.whitesmoke
	for coord in GLOBAL.board_coord_set.array:
		var offset := Hex.to_offset(coord)
		tm.set_cell(offset.x, offset.y, 1)
	
	
	var plant_seed := GLOBAL.board_coord_set.get_random(GLOBAL.rand)
	placed_plants[plant_seed] = true
	var offset = Hex.to_offset(plant_seed)
	$Grids/Plants.set_cell(offset.x, offset.y, 0)
	
	for i in range(5):
		var water_seed := GLOBAL.board_coord_set.get_random(GLOBAL.rand)
		if not placed_plants.has(water_seed):
			offset = Hex.to_offset(water_seed)
			$Grids/Water.set_cell(offset.x, offset.y, 0)
	
	
	$"%PlantCards".modulate.a = 0.5


func _process(delta: float) -> void:
	pass


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed:
			var mouse_pos = get_viewport().canvas_transform.affine_inverse().xform(get_global_mouse_position()) - $Grids.global_position
			var mouse_hex := GLOBAL.pixel_hex_layout.pixel_to_hex(Vector3(mouse_pos.x, mouse_pos.y, 0))
			if current_state == State.SELECT_PLANT:
				if GLOBAL.board_coord_set.has(mouse_hex) and placed_plants.has(mouse_hex):
					var roots := $Grids/Roots
					for coord_delta in GLOBAL.neighbor_coord_set.array:
						var coord = mouse_hex + coord_delta
						if GLOBAL.board_coord_set.has(coord):
							var offset := Hex.to_offset(coord)
							roots.set_cell(offset.x, offset.y, 0)
					$GridAnimations.seek(1, true)
					$GridAnimations.play("RootFlash")
					current_state = State.SELECT_ROOT
			elif current_state == State.SELECT_ROOT:
				if GLOBAL.board_coord_set.has(mouse_hex):
					reset_state()


func _on_root_card_selected(which: int) -> void:
	print("root", which)
	if current_state != State.SELECT_ROOT_CARD:
		return
	next_state()


func _on_plant_card_selected(which: int) -> void:
	if current_state != State.SELECT_PLANT_CARD:
		return
	next_state()
	print("plant", which)


func _on_root_cancel_selected() -> void:
	if current_state == State.SELECT_ROOT_CARD:
		return
	reset_state()
	print("cancel")


func next_state() -> void:
	match current_state:
		State.SELECT_ROOT_CARD:
			current_state = State.SELECT_PLANT
			$GridAnimations.play("PlantFlash")
			$"%RootCards".hide()
			$"%RootCancel".show()
		State.SELECT_PLANT:
			pass
		State.SELECT_ROOT:
			pass
		State.SELECT_PLANT_CARD:
			pass


func reset_state() -> void:
	current_state = State.SELECT_ROOT_CARD
	
	roots_coord_set.clear()
	$Grids/Roots.clear()
	
	$GridAnimations.seek(1, true)
	$GridAnimations.stop()

	$"%RootCards".show()
	$"%RootCancel".hide()
