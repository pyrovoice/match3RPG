extends Object
class_name CardDB
#https://github.com/Card-Forge/forge/blob/master/forge-core/src/main/java/forge/card/CardRules.java#L597
#Load and assign value to cards from text

const cardFolderPath = "res://CardDB/cardTexts/"
const lineDelimiter = '\n'
var allcards: Array[Card] = []

static var instance = null

static func getInstance():
	if instance == null:
		instance = CardDB.new()
	return instance
		
func _init():
	var dir = DirAccess.open(cardFolderPath)
	dir.list_dir_begin()
	var file_name = dir.get_next()
	while file_name != "":
		if !dir.current_is_dir():
			var file = FileAccess.open(cardFolderPath + file_name, FileAccess.READ)
			var content = file.get_as_text(false)
			allcards.push_back(getCardFromTextFile(content))
		file_name = dir.get_next()

func getCardFromTextFile(text: String) -> Card:
	var lines = text.split(lineDelimiter)
	var card:Card = Card.new()
	for line:String in lines:
		var colonPos = line.find(':')
		var key:String = line.substr(0, colonPos) if colonPos > 0 else line
		var value: String = line.substr(1+colonPos).lstrip(' ').rstrip(' ') if colonPos > 0 else ""
		match key[0]:
			"A":
				card.addAbility(value)
			"C":
				if "Colors" == key:
					var colorsValues = value.split(",")
					for c in colorsValues:
						card.addColor(getColorFromString(c))
			"D":
				if "Description" == key:
					card.setDescription(value)
			"K":
				if "K" == key:
					card.addKeyword(value)
			"M":
				if "ManaCost" == key:
					card.setCost(value)
			"N":
				if "Name" == key:
					card.name = value
			"P":
				if "PT" == key:
					var split = value.split("/")
					card.setStrength(split[0])
					card.setLife(split[1])
			"R":
				if "R" == key:
					card.addReplacementEffect(value)


	return card

func getColorFromString(c: String) -> Card.ColorEnum:
	match c:
		"W": return Card.ColorEnum.WHITE
		"G": return Card.ColorEnum.GREEN
		"U": return Card.ColorEnum.BLUE
		"B": return Card.ColorEnum.BLACK
		"R": return Card.ColorEnum.RED
	return Card.ColorEnum.COLORLESS
