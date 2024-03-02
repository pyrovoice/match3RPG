extends Object
class_name ColorNode

static var BLUE = preload("res://resources/blue.tres")
static var GREEN = preload("res://resources/green.tres")
static var RED = preload("res://resources/red.tres")
static var WHITE = preload("res://resources/white.tres")
static var BLACK = preload("res://resources/black.tres")
static var colors = [PColor.BLUE, PColor.GREEN, PColor.RED, PColor.WHITE, PColor.BLACK]
enum PColor{
	BLUE, BLACK, WHITE, RED, GREEN
}
var resource = BLUE
var color: PColor
func _init(_color: PColor):
	color = _color
	match color:
		PColor.BLUE:
			resource = BLUE
		PColor.GREEN:
			resource = GREEN
		PColor.RED:
			resource = RED
		PColor.WHITE:
			resource = WHITE
		PColor.BLACK:
			resource = BLACK

static func getRandom() -> ColorNode:
	return ColorNode.new(colors.pick_random())

static func getColorFromEnum(n: ColorNode) -> String:
	if n == null:
		return "n"
	match n.color:
		PColor.BLUE:
			return "U"
		PColor.GREEN:
			return "G"
		PColor.RED:
			return "R"
		PColor.WHITE:
			return "W"
		PColor.BLACK:
			return "B"
	return "n"
