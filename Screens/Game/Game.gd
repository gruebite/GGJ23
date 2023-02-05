class_name Game extends Node2D

const LIKE_EFFECT := preload("res://UI/Effects/LikeEffect/LikeEffect.tscn")

const FACTORIALS := [
	0, # Here we break math.
	1,
	2,
	6,
	24,
	120,
	720,
]

var turns_remaining := 60
var score := 0

var placed_plants := {}

var roots_coord_set := CoordSet.new()
var root_coord_selected := Vector2.ZERO
var plant_coord_selected := Vector2.ZERO
var plant_cards := [null, null, null]
onready var next_root_card := MODEL.get_random_root_card()
onready var curr_root_card := MODEL.get_random_root_card()

onready var root_card_node := $"%RootCard"
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

	new_game()


func new_game() -> void:
	turns_remaining = 60
	$"%TurnAmount".text = "60"
	score = 0
	$"%PointAmount".text = "0"
	
	$Grids/Plants.clear()
	$Grids/Roots.clear()
	$Grids/Water.clear()
	
	placed_plants.clear()
	next_root_card = MODEL.get_random_root_card()
	curr_root_card = MODEL.get_random_root_card()

	random_generate_level()
	
	var excluding := {}
	for i in range(3):
		plant_cards[i] = MODEL.get_random_plant_card(excluding)
		excluding[i] = true
		plant_cards_node.get_child(i).set_plant_card(plant_cards[i])
	
	# Set to Yggdrasil
	select_plant_coord(plant_coord_selected)
	root_card_node.set_root_card(next_root_card)


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
	
	plant_coord_selected = plant_seed


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed:
			var mouse_pos = get_viewport().canvas_transform.affine_inverse().xform(get_global_mouse_position()) - $Grids.global_position
			var mouse_coord := GLOBAL.pixel_hex_layout.pixel_to_hex(Vector3(mouse_pos.x, mouse_pos.y, 0))
			
			if $"%RadialPlant".visible:
				$"%RadialPlant".hide()
				unselect_coords()
			else:
				if roots_coord_set.has(mouse_coord):
					select_root_coord(mouse_coord)
					var pixel := GLOBAL.pixel_hex_layout.hex_to_pixel(mouse_coord)
					$"%RadialPlant".rect_position = Vector2(pixel.x, pixel.y) + $Grids.global_position
					var scores := calculate_scores(mouse_coord, plant_cards)
					$"%RadialPlant".set_plant_options(plant_cards, scores)
					$"%RadialPlant".show()
					click_sfx()
				else:
					unselect_coords()


func _on_radial_plant_selected(plant_card: PlantCard) -> void:
	$"%RadialPlant".hide()
	$Grids/Roots.clear()
	
	placed_plants[root_coord_selected] = plant_card.type
	var offset := Hex.to_offset(root_coord_selected)
	$Grids/Plants.set_cell(offset.x, offset.y, plant_card.type)
	
	curr_root_card = next_root_card
	next_root_card = MODEL.get_random_root_card()
	select_plant_coord(root_coord_selected)
	root_card_node.set_root_card(next_root_card)
	
	var replace_i := -1
	var exclusions := {}
	for i in plant_cards.size():
		if plant_cards[i].type == plant_card.type:
			replace_i = i
		else:
			exclusions[(plant_cards[i].type)] = true
	
	plant_cards[replace_i] = MODEL.get_random_plant_card(exclusions)
	plant_cards_node.get_child(replace_i).set_plant_card(plant_cards[replace_i])
	
	score_points(root_coord_selected, plant_card.type)
	
	turns_remaining -= 1
	$"%TurnAmount".text = str(turns_remaining)
	if turns_remaining == 0 or roots_coord_set.size() == 0: # No roots available.
		if roots_coord_set.size() == 0:
			$UI/GameOver.set_message("You got stuck!")
		else:
			$UI/GameOver.set_message("")
		$UI/GameOver.set_score(score)
		$UI/GameOver.show()
		game_over_sfx()
	else:
		click_sfx()


func select_plant_coord(plant_coord: Vector2) -> void:
	plant_coord_selected = plant_coord

	var roots_grid := $Grids/Roots
	roots_grid.clear()
	roots_coord_set.clear()
	for coord_delta in curr_root_card.layout.array:
		var coord = plant_coord + coord_delta
		if GLOBAL.board_coord_set.has(coord) and not placed_plants.has(coord):
			roots_coord_set.add(coord)
			var offset := Hex.to_offset(coord)
			roots_grid.set_cell(offset.x, offset.y, 0)


func select_root_coord(root_coord: Vector2) -> void:
	root_coord_selected = root_coord
	roots_coord_set.clear()
	var offset := Hex.to_offset(root_coord)
	$Grids/Roots.set_cell(offset.x, offset.y, 0)


func unselect_coords() -> void:
	select_plant_coord(plant_coord_selected)


func calculate_score(coord: Vector2, plant_type: int) -> int:
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
	
	return like_score - dislike_score


func calculate_scores(coord: Vector2, plants: Array) -> Array:
	var result := [0, 0, 0]
	for i in range(3):
		result[i] = calculate_score(coord, plants[i].type)
	return result


func score_points(coord: Vector2, plant_type: int) -> void:
	var plant_def := MODEL.plants[plant_type] as Dictionary
	
	for coord_delta in GLOBAL.neighbor_coord_set.array:
		var neigh := (coord + coord_delta) as Vector2
		if not GLOBAL.board_coord_set.has(neigh):
			continue
		
		var like_effect = null
		
		if placed_plants.has(neigh):
			var neigh_type := placed_plants[neigh] as int
			if plant_def.likes.has(neigh_type):
				like_effect = LIKE_EFFECT.instance()
				like_effect.set_like(true)
			elif plant_def.dislikes.has(neigh_type):
				like_effect = LIKE_EFFECT.instance()
				like_effect.set_like(false)
		
		if like_effect:
			var pos := GLOBAL.pixel_hex_layout.hex_to_pixel(neigh)
			like_effect.position = Vector2(pos.x, pos.y) + $Grids.global_position
			$UI/Effects.add_child(like_effect)
	
	score += calculate_score(coord, plant_type)
	
	$"%PointAmount".text = str(score)


func _on_audio_toggled(pressed: bool) -> void:
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), pressed)
	click_sfx()


func _on_game_over_again() -> void:
	new_game()
	$UI/GameOver.hide()
	game_start_sfx()


func _on_game_over_exit() -> void:
	get_tree().change_scene("res://Screens/Title/Title.tscn")


func click_sfx() -> void:
	$ClickSound.play()


func game_over_sfx() -> void:
	$GameOverSound.play()


func game_start_sfx() -> void:
	$GameStartSound.play()
