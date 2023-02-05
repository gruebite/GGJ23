class_name Model extends Node


enum Plant {
	WATER,
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
		"name": "Water",
		"texture": preload("res://Assets/Textures/Water.png"),
		"likes": {},
		"dislikes": {},
	},
	{
		"name": "Yggdrasil",
		"texture": preload("res://Assets/Textures/WorldTree.png"),
		"likes": {},
		"dislikes": {},
	},
	{
		"name": "Mighty Oak",
		"texture": preload("res://Assets/Textures/MightyOak.png"),
		"likes": {},
		"dislikes": {Plant.MIGHTY_OAK: true, Plant.CONY_FIERCE: true, Plant.SQUIRREL_CORN: true},
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

var plant_cards := []
var root_cards := []

func _ready() -> void:
	for i in range(60):
		if i < 20:
			plant_cards.append(PlantCard.new(Plant.MIGHTY_OAK))
		elif i < 40:
			plant_cards.append(PlantCard.new(Plant.CATS_TAIL))
		else:
			plant_cards.append(PlantCard.new(Plant.BALL_CAP))

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
