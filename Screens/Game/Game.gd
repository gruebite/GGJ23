class_name Game extends Node2D

enum State {
	SELECT_ROOT_CARD,
	SELECT_PLANT,
	SELECT_ROOT,
	SELECT_PLANT_CARD,
}

var placed_plants := {}
var placed_water := {}
var current_state := State.SELECT_ROOT_CARD as int

var roots_coord_set := CoordSet.new()
var root_selected := Vector2.ZERO

onready var plant_deck := CardDeck.new(MODEL.plant_cards)
onready var root_deck := CardDeck.new(MODEL.root_cards)

onready var root_cards_node := $"%RootCards"
onready var plant_cards_node := $"%PlantCards"

func _ready() -> void:
	var tm := $Grids/Terrain as TileMap
	tm.modulate = Color.whitesmoke
	for coord in GLOBAL.board_coord_set.array:
		var offset := Hex.to_offset(coord)
		tm.set_cell(offset.x, offset.y, 1)

	random_generate_level()
	
	root_cards_node.get_child(0).set_root_card(root_deck.draw_card())
	root_cards_node.get_child(1).set_root_card(root_deck.draw_card())
	plant_cards_node.get_child(0).set_plant_card(plant_deck.draw_card())
	plant_cards_node.get_child(1).set_plant_card(plant_deck.draw_card())
	
	$"%PlantCards".modulate.a = 0.5

func random_generate_level() -> void:
	
	var offset
	
	# lake gen
	var current_pos := GLOBAL.board_coord_set.get_random(GLOBAL.rand)
	placed_water[current_pos]=true
	offset = Hex.to_offset(current_pos)
	$Grids/Water.set_cell(offset.x, offset.y, 0)
	for i in range(10):
		
		var candidate = Hex.get_neighbor(current_pos, GLOBAL.rand.rangei(0,5))
		if GLOBAL.board_coord_set.has(candidate):
			print("right!", current_pos, candidate)
			current_pos = candidate
			placed_water[current_pos]=true
			offset = Hex.to_offset(current_pos)
			$Grids/Water.set_cell(offset.x, offset.y, 0)
		else:
			print("wrong!", current_pos, candidate)

	var plant_seed := GLOBAL.board_coord_set.get_random(GLOBAL.rand)
	# make sure no water is in the way
	while placed_water.has(plant_seed):
		plant_seed = GLOBAL.board_coord_set.get_random(GLOBAL.rand)
	placed_plants[plant_seed] = true
	offset = Hex.to_offset(plant_seed)
	$Grids/Plants.set_cell(offset.x, offset.y, 0)


func _process(delta: float) -> void:
	pass


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed:
			var mouse_pos = get_viewport().canvas_transform.affine_inverse().xform(get_global_mouse_position()) - $Grids.global_position
			var mouse_coord := GLOBAL.pixel_hex_layout.pixel_to_hex(Vector3(mouse_pos.x, mouse_pos.y, 0))
			
			var roots_grid := $Grids/Roots
			if current_state == State.SELECT_PLANT:
				if GLOBAL.board_coord_set.has(mouse_coord) and placed_plants.has(mouse_coord):
					roots_coord_set.clear()
					for coord_delta in GLOBAL.neighbor_coord_set.array:
						var coord = mouse_coord + coord_delta
						if GLOBAL.board_coord_set.has(coord) and not placed_plants.has(coord):
							roots_coord_set.add(coord)
							var offset := Hex.to_offset(coord)
							roots_grid.set_cell(offset.x, offset.y, 0)
					$GridAnimations.seek(1, true)
					$GridAnimations.play("RootFlash")
					current_state = State.SELECT_ROOT
			elif current_state == State.SELECT_ROOT:
				if roots_coord_set.has(mouse_coord):
					root_selected = mouse_coord
					roots_grid.clear()
					var offset := Hex.to_offset(mouse_coord)
					roots_grid.set_cell(offset.x, offset.y, 0)
					$"%PlantCards".modulate.a = 1
					current_state = State.SELECT_PLANT_CARD


func _on_root_card_selected(which: int) -> void:
	if current_state != State.SELECT_ROOT_CARD:
		return
	
	current_state = State.SELECT_PLANT
	$GridAnimations.play("PlantFlash")
	$"%RootCards".hide()
	$"%RootCancel".show()
	print("root", which)


func _on_plant_card_selected(which: int) -> void:
	if current_state != State.SELECT_PLANT_CARD:
		return
	
	$Grids/Roots.clear()
	placed_plants[root_selected] = true
	var offset := Hex.to_offset(root_selected)
	$Grids/Plants.set_cell(offset.x, offset.y, 1)
	reset_state()
	print("plant", which)


func _on_root_cancel_selected() -> void:
	if current_state == State.SELECT_ROOT_CARD:
		return
	reset_state()
	print("cancel")


func reset_state() -> void:
	current_state = State.SELECT_ROOT_CARD
	
	roots_coord_set.clear()
	$Grids/Roots.clear()
	
	$GridAnimations.seek(1, true)
	$GridAnimations.stop()

	$"%RootCards".show()
	$"%RootCancel".hide()
	$"%PlantCards".modulate.a = 0.5
