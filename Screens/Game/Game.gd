class_name Game extends Node2D

enum State {
	SELECT_ROOT_CARD,
	SELECT_PLANT,
	SELECT_ROOT,
	SELECT_PLANT_CARD,
}

const FACTORIALS := [
	0, # Here we break math.
	1,
	2,
	6,
	24,
	120,
	720,
]

var score := 0
var score_bank := 0

var placed_plants := {}
var current_state := State.SELECT_ROOT_CARD as int

var roots_coord_set := CoordSet.new()

var root_coord_selected := Vector2.ZERO
var root_card_selected: int
var plant_card_selected: int
var root_card_dock := [null, null]
var plant_card_dock := [null, null]

onready var plant_deck := MODEL.construct_plant_deck()
onready var root_deck := MODEL.construct_root_deck()

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
		tm.set_cell(offset.x, offset.y, 3)

	random_generate_level()
	
	for i in range(2):
		root_card_dock[i] = root_deck.draw_card()
		root_cards_node.get_child(i).set_root_card(root_card_dock[i])
		plant_card_dock[i] = plant_deck.draw_card()
		plant_cards_node.get_child(i).set_plant_card(plant_card_dock[i])
	
	$"%PlantLabel".modulate.a = 0.75
	$"%PlantCards".modulate.a = 0.75



func random_generate_level() -> void:
	var offset
	var candidate
	
	# lake gen
	var lake_seed := GLOBAL.board_coord_set.get_random(GLOBAL.rand)
	placed_plants[lake_seed] = Model.Plant.WATER
	offset = Hex.to_offset(lake_seed)
	$Grids/Water.set_cell(offset.x, offset.y, Model.Plant.WATER)
	var current_pos = lake_seed
	for i in range(MAX_LAKE_SIZE):
		candidate = Hex.get_neighbor(current_pos, GLOBAL.rand.rangei(0,5))
		if GLOBAL.board_coord_set.has(candidate):
			if i>CORE_LAKE_SIZE:
				# Spread out from lake center
				current_pos = candidate
			placed_plants[candidate] = Model.Plant.WATER
			offset = Hex.to_offset(candidate)
			$Grids/Water.set_cell(offset.x, offset.y, Model.Plant.WATER)
			
	# river gen
	var ring = HexSets.ring(RIVER_RING_RADIUS)
	var center_of_ring = GLOBAL.rand.choice(RIVER_CENTERS)
	for i in range(ring.get_size()):
		candidate = ring.array[i] + center_of_ring
		if GLOBAL.board_coord_set.has(candidate):
			placed_plants[candidate] = Model.Plant.WATER
			offset = Hex.to_offset(candidate)
			$Grids/Water.set_cell(offset.x, offset.y, Model.Plant.WATER)

	# Main plant gen
	var plant_seed := GLOBAL.board_coord_set.get_random(GLOBAL.rand)
	# make sure no water is in the way
	while placed_plants.has(plant_seed):
		plant_seed = GLOBAL.board_coord_set.get_random(GLOBAL.rand)
	placed_plants[plant_seed] = Model.Plant.YGGDRASIL
	offset = Hex.to_offset(plant_seed)
	$Grids/Plants.set_cell(offset.x, offset.y, Model.Plant.YGGDRASIL)


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
					$"%HelpLabel".text = "Select root to grow plant from"
					current_state = State.SELECT_ROOT
			elif current_state == State.SELECT_ROOT:
				if roots_coord_set.has(mouse_coord):
					root_coord_selected = mouse_coord
					roots_grid.clear()
					var offset := Hex.to_offset(mouse_coord)
					roots_grid.set_cell(offset.x, offset.y, 0)
					$"%RootLabel".modulate.a = 0.75
					$"%PlantLabel".modulate.a = 1
					$"%PlantCards".modulate.a = 1
					$"%HelpLabel".text = "Select plant"
					current_state = State.SELECT_PLANT_CARD


func _on_root_card_selected(which: int) -> void:
	if current_state != State.SELECT_ROOT_CARD:
		return
	
	root_card_selected = which
	current_state = State.SELECT_PLANT
	$GridAnimations.play("PlantFlash")
	$"%RootCards".hide()
	$"%RootCancel".show()
	$"%HelpLabel".text = "Select plant to grow roots from"
	print("root", which)


func _on_plant_card_selected(which: int) -> void:
	if current_state != State.SELECT_PLANT_CARD:
		return
	
	plant_card_selected = which
	$Grids/Roots.clear()
	placed_plants[root_coord_selected] = plant_card_dock[which].type
	var offset := Hex.to_offset(root_coord_selected)
	$Grids/Plants.set_cell(offset.x, offset.y, plant_card_dock[which].type)
	reset_state()
	
	root_card_dock[root_card_selected] = root_deck.draw_card()
	root_cards_node.get_child(root_card_selected).set_root_card(root_card_dock[root_card_selected])
	plant_card_dock[plant_card_selected] = plant_deck.draw_card()
	plant_cards_node.get_child(plant_card_selected).set_plant_card(plant_card_dock[plant_card_selected])
	$"%TurnAmount".text = str(root_deck.remaining() + 2)
	
	score_points(root_coord_selected)
	
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
	
	$"%HelpLabel".text = ""

	$"%RootCards".show()
	$"%RootCancel".hide()
	$"%RootLabel".modulate.a = 1
	$"%PlantLabel".modulate.a = 0.75
	$"%PlantCards".modulate.a = 0.75


func score_points(coord: Vector2) -> void:
	var plant_type := placed_plants[coord] as int
	var plant_def := MODEL.plants[plant_type] as Dictionary
	
	var like_count := 0
	var dislike_count := 0
	
	for coord_delta in GLOBAL.neighbor_coord_set.array:
		var neigh := (coord + coord_delta) as Vector2
		if not GLOBAL.board_coord_set.has(neigh):
			continue
		
		if placed_plants.has(neigh):
			var neigh_type := placed_plants[neigh] as int
			if plant_def.likes.has(neigh_type):
				like_count += 1
			elif plant_def.dislikes.has(neigh_type):
				dislike_count += 1
	
	var like_score = FACTORIALS[like_count]
	var dislike_score = FACTORIALS[dislike_count]
	
	score += like_score - dislike_score
	
	$"%PointAmount".text = str(score)


func _on_audio_toggled(pressed: bool) -> void:
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), pressed)
