class_name Model extends Node

enum Plant {
	WATER,
	YGGDRASIL,
	MIGHTY_OAK,
	CONY_FIERCE,
	ROCK_SUCCULENT,
	GRASS,
	BALL_CAP,
	SNOOZE_BERRIES,
	SUN_FLOWER,
	CATS_TAIL,
	RABBITS_FOOT,
	SQUIRREL_CORN,
	FROG_FERN,
	BIRD_OF_PARADISE,
	BEARS_PAW,
	WOLFS_BANE,
	BEE_ORCHID,
	HIVE_SUCCULENT,
	SPIDER_PLANT,
}

var plants := [
	{
		"name": "Water",
		"texture": preload("res://Assets/Textures/Water.png"),
		"likes": {},
		"dislikes": {},
		"weight": 0,
	},
	{
		"name": "Yggdrasil",
		"texture": preload("res://Assets/Textures/WorldTree.png"),
		"likes": {},
		"dislikes": {},
		"weight": 0,
	},
	{
		"name": "Mighty Oak",
		"texture": preload("res://Assets/Textures/MightyOak.png"),
		"likes": {},
		"dislikes": {Plant.MIGHTY_OAK: true, Plant.CONY_FIERCE: true, Plant.SQUIRREL_CORN: true},
		"weight": 10,
	},
	{
		"name": "Cony Fierce",
		"texture": preload("res://Assets/Textures/ConyFierce.png"),
		"likes": {Plant.ROCK_SUCCULENT: true, Plant.BALL_CAP: true, Plant.CONY_FIERCE: true},
		"dislikes": {Plant.MIGHTY_OAK: true},
		"weight": 10,
	},
	{
		"name": "Rock Succulent",
		"texture": preload("res://Assets/Textures/Roots.png"),
		"likes": {Plant.ROCK_SUCCULENT: true},
		"dislikes": {Plant.WATER: true},
		"weight": 2,
	},
	{
		"name": "Grass",
		"texture": preload("res://Assets/Textures/Grass.png"),
		"likes": {Plant.BEE_ORCHID: true},
		"dislikes": {Plant.MIGHTY_OAK: true, Plant.CONY_FIERCE: true, Plant.ROCK_SUCCULENT: true},
		"weight": 4,
	},
	{
		"name": "Ball Cap",
		"texture": preload("res://Assets/Textures/BallCap.png"),
		"likes": {Plant.MIGHTY_OAK: true, Plant.CONY_FIERCE: true, Plant.WATER: true},
		"dislikes": {Plant.RABBITS_FOOT: true, Plant.SQUIRREL_CORN: true, Plant.BIRD_OF_PARADISE: true},
		"weight": 3,
	},
	{
		"name": "Snooze Berries",
		"texture": preload("res://Assets/Textures/Roots.png"),
		"likes": {Plant.MIGHTY_OAK: true, Plant.CONY_FIERCE: true, Plant.GRASS: true},
		"dislikes": {Plant.WATER: true},
		"weight": 5,
	},
	{
		"name": "Sun Flower",
		"texture": preload("res://Assets/Textures/SunFlower.png"),
		"likes": {Plant.BEE_ORCHID: true},
		"dislikes": {Plant.RABBITS_FOOT: true},
		"weight": 3,
	},
	{
		"name": "Cat's Tail",
		"texture": preload("res://Assets/Textures/CatsTail.png"),
		"likes": {Plant.WATER: true},
		"dislikes": {Plant.BALL_CAP: true},
		"weight": 5,
	},
	{
		"name": "Rabbit's Foot",
		"texture": preload("res://Assets/Textures/Roots.png"),
		"likes": {Plant.BIRD_OF_PARADISE: true, Plant.SUN_FLOWER: true, Plant.GRASS: true},
		"dislikes": {Plant.WOLFS_BANE: true, Plant.BIRD_OF_PARADISE: true},
		"weight": 3,
	},
	{
		"name": "Squirrel Corn",
		"texture": preload("res://Assets/Textures/SquirrelCorn.png"),
		"likes": {Plant.MIGHTY_OAK: true, Plant.CONY_FIERCE: true},
		"dislikes": {Plant.WOLFS_BANE: true, Plant.BIRD_OF_PARADISE: true},
		"weight": 4,
	},
	{
		"name": "Frog Fern",
		"texture": preload("res://Assets/Textures/FrogFern.png"),
		"likes": {Plant.WATER: true, Plant.BEE_ORCHID: true, Plant.SPIDER_PLANT: true, Plant.ROCK_SUCCULENT: true},
		"dislikes": {Plant.WOLFS_BANE: true, Plant.BIRD_OF_PARADISE: true},
		"weight": 4,
	},
	{
		"name": "Bird Of Paradise",
		"texture": preload("res://Assets/Textures/BirdOfParadise.png"),
		"likes": {Plant.MIGHTY_OAK: true, Plant.CONY_FIERCE: true, Plant.BIRD_OF_PARADISE: true, Plant.SUN_FLOWER: true, Plant.BEE_ORCHID: true},
		"dislikes": {Plant.CATS_TAIL: true},
		"weight": 2,
	},
	{
		"name": "Bear's Paw",
		"texture": preload("res://Assets/Textures/BearsPaw.png"),
		"likes": {Plant.HIVE_SUCCULENT: true, Plant.RABBITS_FOOT: true, Plant.SNOOZE_BERRIES: true},
		"dislikes": {Plant.BEE_ORCHID: true, Plant.WOLFS_BANE: true},
		"weight": 2,
	},
	{
		"name": "Wolf's Bane",
		"texture": preload("res://Assets/Textures/Roots.png"),
		"likes": {Plant.CATS_TAIL: true, Plant.SQUIRREL_CORN: true, Plant.FROG_FERN: true},
		"dislikes": {Plant.WATER: true, Plant.MIGHTY_OAK: true, Plant.CONY_FIERCE: true, Plant.BEE_ORCHID: true, Plant.BEARS_PAW: true},
		"weight": 1,
	},
	{
		"name": "Bee Orchid",
		"texture": preload("res://Assets/Textures/BeeOrchid.png"),
		"likes": {Plant.HIVE_SUCCULENT: true, Plant.BEE_ORCHID: true, Plant.SUN_FLOWER: true, Plant.BIRD_OF_PARADISE: true},
		"dislikes": {Plant.BEARS_PAW: true},
		"weight": 3,
	},
	{
		"name": "Hive Succulent",
		"texture": preload("res://Assets/Textures/HiveSucculent.png"),
		"likes": {Plant.MIGHTY_OAK: true, Plant.CONY_FIERCE: true},
		"dislikes": {Plant.WATER: true, Plant.BEARS_PAW: true, Plant.SPIDER_PLANT: true},
		"weight": 1,
	},
	{
		"name": "Spider Plant",
		"texture": preload("res://Assets/Textures/SpiderPlant.png"),
		"likes": {Plant.MIGHTY_OAK: true, Plant.CONY_FIERCE: true, Plant.BEE_ORCHID: true},
		"dislikes": {Plant.WATER: true, Plant.GRASS: true, Plant.SPIDER_PLANT: true},
		"weight": 2,
	},
]


enum Root {
	CrossS,
	CrossM,
	XrossS,
	XrossM,
	VerticalReachM,
	HorizontalReachM,
}

const root_layout_names := [
	"Cross S",
	"Cross M",
	"Xross S",
	"Xross M",
	'Vertical Reach M',
	'Horizontal Reach M'
]

var root_layouts := [
	CoordSet.new([Hex.east(), Hex.diagonal_south(), Hex.west(), Hex.diagonal_north()]),
	CoordSet.new([Hex.east(), Hex.east()*2, Hex.diagonal_south() ,Hex.west(), Hex.west()*2, Hex.diagonal_north()]),
	CoordSet.new([Hex.northeast(), Hex.southeast(), Hex.southwest(), Hex.northwest()]),
	CoordSet.new([Hex.northeast(), Hex.southeast(), Hex.southwest(), Hex.northwest(), Hex.northeast()*2, Hex.southeast()*2, Hex.southwest()*2, Hex.northwest()*2]),
	CoordSet.new([Hex.diagonal_south(), Hex.southeast(), Hex.southeast()*2, Hex.southwest(), Hex.southwest()*2, Hex.diagonal_north(), Hex.northeast(), Hex.northeast()*2, Hex.northwest(), Hex.northwest()*2]),
	CoordSet.new([Hex.east(), Hex.east()*2, Hex.west(), Hex.west()*2, Hex.diagonal_northeast(), Hex.diagonal_northwest(), Hex.diagonal_southeast(), Hex.diagonal_southwest()]),
]


func construct_root_deck() -> CardDeck:
	var root_cards := []
	for i in range(60):
		if i < 10:
			root_cards.append(RootCard.new(Root.CrossS))
		elif i < 20:
			root_cards.append(RootCard.new(Root.CrossM))
		elif i < 30:
			root_cards.append(RootCard.new(Root.XrossS))
		elif i < 40:
			root_cards.append(RootCard.new(Root.XrossM))
		elif i < 50:
			root_cards.append(RootCard.new(Root.VerticalReachM))
		else:
			root_cards.append(RootCard.new(Root.HorizontalReachM))
	
	return CardDeck.new(root_cards)


func construct_plant_deck() -> CardDeck:
	var plant_cards := []

	var total_plant_weight := 0
	for def in plants:
		total_plant_weight += def.weight

	for _i in range(60):
		var r := GLOBAL.rand.rangei(0, total_plant_weight)
		for i in range(plants.size()):
			r -= plants[i].weight
			if r < 0:
				plant_cards.append(PlantCard.new(i))
				break
	
	return CardDeck.new(plant_cards)
