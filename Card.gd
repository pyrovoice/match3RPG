extends Object
class_name Card

enum CardTypeEnum{
	CREATURE,
	SPELL
}
enum ColorEnum{
	COLORLESS,
	BLUE,
	GREEN,
	RED,
	BLACK,
	WHITE,
	GOLD
}
var name:String
var manaCost:int
var cardType: CardTypeEnum
var colors: Array[ColorEnum]
var strength: int
var life: int

func _init(_name = "test", _manaRequired = 2, _cardType = CardTypeEnum.CREATURE, _colors = [ColorEnum.COLORLESS]):
	name = _name
	manaCost = _manaRequired
	cardType = _cardType
	colors = _colors

static func getCardCreature(_name, _manaRequired, _colors, _strength, _life):
	var card = Card.new(_name, _manaRequired, CardTypeEnum.CREATURE, _colors)
	card.strength = _strength
	card._life = _life
	return card
