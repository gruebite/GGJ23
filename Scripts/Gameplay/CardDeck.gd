class_name CardDeck extends Reference

var backing: Array
var cards := []


func _init(backing_cards: Array) -> void:
	backing = backing_cards
	reset()


func reset() -> void:
	cards.clear()
	cards.append_array(backing)
	cards.shuffle()
	

func remaining() -> int:
	return cards.size()
	
	
func draw_card() -> Card:
	return cards.pop_back()
