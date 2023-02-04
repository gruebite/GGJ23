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

func _ready() -> void:
	var tm := $Grids/Terrain as TileMap
	tm.modulate = Color.whitesmoke
	for coord in GLOBAL.board_hex_set.array:
		var offset := Hex.to_offset(coord)
		tm.set_cell(offset.x, offset.y, 1)
	
	
	var plant_seed := GLOBAL.board_hex_set.get_random(GLOBAL.rand)
	placed_plants[plant_seed] = true
	var offset = Hex.to_offset(plant_seed)
	$Grids/Plants.set_cell(offset.x, offset.y, 0)
	
	for i in range(5):
		var water_seed := GLOBAL.board_hex_set.get_random(GLOBAL.rand)
		if not placed_plants.has(water_seed):
			offset = Hex.to_offset(water_seed)
			$Grids/Water.set_cell(offset.x, offset.y, 0)
	
	
	$"%PlantCards".modulate.a = 0.5


func _process(delta: float) -> void:
	var hl := $Grids/Highlight as TileMap
	hl.clear()
	
	var mouse_pos = get_global_mouse_position() - $Grids.global_position
	var mouse_hex := GLOBAL.pixel_hex_layout.pixel_to_hex(Vector3(mouse_pos.x, mouse_pos.y, 0))
	if GLOBAL.board_hex_set.has(mouse_hex):
		var offset := Hex.to_offset(mouse_hex)
		hl.set_cell(offset.x, offset.y, 2)


func _on_root_selected(which: int) -> void:
	if current_state != State.SELECT_ROOT_CARD:
		return
	$Animations.play("PlantFlash")
	call_deferred("set", "current_state", State.SELECT_PLANT)
	$"%RootCards".hide()
	$"%RootCancel".show()
	print("root", which)


func _on_plant_selected(which: int) -> void:
	if current_state != State.SELECT_PLANT_CARD:
		return
	print("plant", which)


func _on_root_cancel_selected() -> void:
	if current_state != State.SELECT_PLANT:
		return
	call_deferred("set", "current_state", State.SELECT_ROOT_CARD)
	$Animations.seek(1, true)
	$Animations.stop()
	$"%RootCards".show()
	$"%RootCancel".hide()
	print("cancel")


func _on_plant_cancel_selected() -> void:
	pass # Replace with function body.
