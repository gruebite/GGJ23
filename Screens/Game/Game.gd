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
var root_card_selected: int
var plant_card_selected: int
var root_card_dock := [null, null]
var plant_card_dock := [null, null]

onready var plant_deck := CardDeck.new(MODEL.plant_cards)
onready var root_deck := CardDeck.new(MODEL.root_cards)

onready var root_cards_node := $"%RootCards"
onready var plant_cards_node := $"%PlantCards"

# World gen constants
const MAX_LAKE_SIZE=10
const CORE_LAKE_SIZE=5
const RIVER_RING_RADIUS=7
const RIVER_CENTERS=[
	Vector2(0,-4),
	Vector2(-5,2),
	Vector2(-8,8),
	Vector2(-8,14),
	Vector2(0,14),
	Vector2(6,13),
	Vector2(10,6),
	Vector2(11,-1),
	Vector2(14,-4)]
	
func _ready() -> void:
	var tm := $Grids/Terrain as TileMap
	tm.modulate = Color.whitesmoke
	for coord in GLOBAL.board_coord_set.array:
		var offset := Hex.to_offset(coord)
		tm.set_cell(offset.x, offset.y, 1)

	random_generate_level()
	
	for i in range(2):
		root_card_dock[i] = root_deck.draw_card()
		root_cards_node.get_child(i).set_root_card(root_card_dock[i])
		plant_card_dock[i] = plant_deck.draw_card()
		plant_cards_node.get_child(i).set_plant_card(plant_card_dock[i])
	
	$"%PlantCards".modulate.a = 0.5


func random_generate_level() -> void:
	var offset
	var candidate
	
	# lake gen
	var lake_seed := GLOBAL.board_coord_set.get_random(GLOBAL.rand)
	placed_water[lake_seed]=true
	offset = Hex.to_offset(lake_seed)
	$Grids/Water.set_cell(offset.x, offset.y, 0)
	var current_pos = lake_seed
	for i in range(MAX_LAKE_SIZE):
		candidate = Hex.get_neighbor(current_pos, GLOBAL.rand.rangei(0,5))
		if GLOBAL.board_coord_set.has(candidate):
			if i>CORE_LAKE_SIZE:
				# Spread out from lake center
				current_pos = candidate
			placed_water[candidate]=true
			offset = Hex.to_offset(candidate)
			$Grids/Water.set_cell(offset.x, offset.y, 0)
			
	# river gen
	var ring = HexSets.ring(RIVER_RING_RADIUS)
	var center_of_ring = GLOBAL.rand.choice(RIVER_CENTERS)
	for i in range(ring.get_size()):
		candidate = ring.array[i] + center_of_ring
		if GLOBAL.board_coord_set.has(candidate):
			placed_water[candidate]=true
			offset = Hex.to_offset(candidate)
			$Grids/Water.set_cell(offset.x, offset.y, 0)

	# Main plant gen
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
					for coord_delta in root_card_dock[root_card_selected].layout.array:
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
	
	root_card_selected = which
	current_state = State.SELECT_PLANT
	$GridAnimations.play("PlantFlash")
	$"%RootCards".hide()
	$"%RootCancel".show()
	print("root", which)


func _on_plant_card_selected(which: int) -> void:
	if current_state != State.SELECT_PLANT_CARD:
		return
	
	plant_card_selected = which
	$Grids/Roots.clear()
	placed_plants[root_selected] = true
	var offset := Hex.to_offset(root_selected)
	$Grids/Plants.set_cell(offset.x, offset.y, 1)
	reset_state()
	root_card_dock[root_card_selected] = root_deck.draw_card()
	plant_card_dock[plant_card_selected] = plant_deck.draw_card()
	$UI/Root/TitleBar/Turns/Amount.text = str(root_deck.remaining() + 2)
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
