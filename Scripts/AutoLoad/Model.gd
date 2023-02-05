class_name Model extends Node


enum Plant {
	ALL = -1,
	YGGDRASIL,
	MIGHTY_OAK,
}

var plants := [
	{
		"name": "Yggdrasil",
		"likes": {Plant.ALL: true},
		"dislikes": {},
	},
	{
		"name": "Mighty Oak",
		"likes": {},
		"dislikes": {Plant.MIGHTY_OAK: true},
	},
]


enum Roots {
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

func _ready() -> void:
	pass
