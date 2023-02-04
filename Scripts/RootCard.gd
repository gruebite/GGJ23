extends Card

class_name RootCard
var type :String


func _init(card_type: String) -> void:
	if ROOT_LAYOUT_NAMES.has(card_type):
		type = card_type
	else:
		print(card_type, " not supported!")

const ROOT_LAYOUT_NAMES := [
	"Cross S",
	"cross M",
	"Xross S",
	'Vertical Reach M',
	'Horizontal Reach M'
]

var ROOT_LAYOUT_COORDS:= [
		CoordSet.new([Hex.east(), Hex.south(), Hex.west(), Hex.north()]),
		CoordSet.new([Hex.east(), Hex.east()*2, Hex.south(), Hex.south()*2 ,Hex.west(), Hex.west()*2, Hex.north(), Hex.north()*2]),
		CoordSet.new([Hex.northeast(), Hex.southeast(), Hex.southwest(), Hex.northwest()]),
		CoordSet.new([Hex.south()*2,Hex.north()*2]),
		CoordSet.new([Hex.east()*2,Hex.west()*2]),
		]
	
