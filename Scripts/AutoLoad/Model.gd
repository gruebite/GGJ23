class_name Model extends Node


enum Plant {
	WATER = -2,
	ALL = -1,
	YGGDRASIL,
	MIGHTY_OAK,
	CONY_FIERCE,
	BALL_CAP,
	SUN_FLOWER,
	CATS_TAIL,
	RABBITS_FOOT,
	SQUIRREL_CORN,
	FRON_FERN,
}

var plants := [
	{
		"name": "Yggdrasil",
		"texture": preload("res://Assets/Textures/WorldTree.png"),
		"likes": {Plant.ALL: true},
		"dislikes": {},
	},
	{
		"name": "Mighty Oak",
		"texture": preload("res://Assets/Textures/MightyOak.png"),
		"likes": {},
		"dislikes": {Plant.MIGHTY_OAK: true},
	},
	{
		"name": "Cony Fierce",
		"texture": preload("res://Assets/Textures/CatsTail.png"),
		"likes": {Plant.WATER: true},
		"dislikes": {Plant.BALL_CAP: true},
	},
	{
		"name": "Ball Cap",
		"texture": preload("res://Assets/Textures/CatsTail.png"),
		"likes": {Plant.MIGHTY_OAK: true, Plant.CONY_FIERCE: true},
		"dislikes": {Plant.MIGHTY_OAK: true},
	},
	{
		"name": "Sun Flower",
		"texture": preload("res://Assets/Textures/CatsTail.png"),
		"likes": {Plant.WATER: true},
		"dislikes": {Plant.BALL_CAP: true},
	},
	{
		"name": "Cat's Tail",
		"texture": preload("res://Assets/Textures/CatsTail.png"),
		"likes": {Plant.WATER: true},
		"dislikes": {Plant.BALL_CAP: true},
	},
	{
		"name": "Rabbit's Foot",
		"texture": preload("res://Assets/Textures/CatsTail.png"),
		"likes": {Plant.WATER: true},
		"dislikes": {Plant.BALL_CAP: true},
	},
	{
		"name": "Squirrel Corn",
		"texture": preload("res://Assets/Textures/CatsTail.png"),
		"likes": {Plant.WATER: true},
		"dislikes": {Plant.BALL_CAP: true},
	},
	{
		"name": "Frog Fern",
		"texture": preload("res://Assets/Textures/CatsTail.png"),
		"likes": {Plant.WATER: true},
		"dislikes": {Plant.BALL_CAP: true},
	},
]


enum Root {
	CrossS,
	CrossM,
	XrossS,
	VerticalReachM,
	HorizontalReachM,
}

const root_layout_names := [
	"Cross S",
	"Cross M",
	"Xross S",
	'Vertical Reach M',
	'Horizontal Reach M'
]

var root_layouts := [
	CoordSet.new([Hex.east(), Hex.diagonal_south(), Hex.west(), Hex.diagonal_north()]),
	CoordSet.new([Hex.east(), Hex.east()*2, Hex.diagonal_south(), Hex.southeast()*2 ,Hex.west(), Hex.west()*2, Hex.diagonal_north(), Hex.diagonal_north()*2]),
	CoordSet.new([Hex.northeast(), Hex.southeast(), Hex.southwest(), Hex.northwest()]),
	CoordSet.new([Hex.diagonal_south()*2,Hex.diagonal_north()*2]),
	CoordSet.new([Hex.east()*2,Hex.west()*2]),
]

var plant_cards := []
var root_cards := []

func _ready() -> void:
	for i in range(60):
		plant_cards.append(PlantCard.new(Plant.MIGHTY_OAK))

	for i in range(60):
		if i < 30:
			root_cards.append(RootCard.new(Root.CrossS))
		else:
			root_cards.append(RootCard.new(Root.CrossM))
