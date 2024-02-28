extends MarginContainer

@onready var grid_container = $GridContainer
const BLUE = preload("res://resources/blue.tres")
const GREEN = preload("res://resources/green.tres")
const RED = preload("res://resources/red.tres")
const WHITE = preload("res://resources/white.tres")
const BLACK = preload("res://resources/black.tres")
const colors = [BLUE, GREEN, RED, WHITE, BLACK]
const moveDelay = 0.2
const sizeX = 5
const sizeY = 5
var array
var lastSelected
var score = 0

func _ready():
	for child in grid_container.get_children():
		child.queue_free()
	grid_container.columns = sizeX
	
	for i in range(0, sizeX):
		for y in range(0, sizeY):
			grid_container.add_child(getRec(colors.pick_random()))
	

func getRec(resource):
	var newRec:TextureButton = TextureButton.new()
	newRec.texture_normal = resource
	newRec.stretch_mode = TextureButton.STRETCH_KEEP
	newRec.size_flags_horizontal = 6
	newRec.button_down.connect(func(): setSelected(newRec))
	newRec.button_up.connect(func(): unselect(newRec))
	newRec.mouse_entered.connect(func(): onMouseEnter(newRec))
	return newRec

func setSelected(button):
	lastSelected = button

func unselect(button):
	if lastSelected == button:
		lastSelected = null

func onMouseEnter(button):
	if lastSelected:
		switchTwoElements(lastSelected, button)
		lastSelected = null

func switchTwoElements(first: TextureButton, second: TextureButton):
	var firstIndex = first.get_index()
	var secondIndex = second.get_index()
	var firstPosition = first.position
	var secondPosition = second.position
	first.position = firstPosition
	second.position = secondPosition
	var tween = get_tree().create_tween()
	tween.tween_property(first, "position", secondPosition, moveDelay)
	tween.parallel().tween_property(second, "position", firstPosition, moveDelay)
	tween.tween_callback(func(): grid_container.move_child(first, secondIndex))
	tween.tween_callback(func(): grid_container.move_child(second, firstIndex))
	tween.tween_callback(func(): checkForMatches())

func checkForMatches():
	var markedForDeletion = []
	for x in range(0, sizeX-2):
		for y in range(0, sizeY-2):
			var counter = 1
			counter += countElementGoing(x, y, true)
			if counter >= 3:
				for n in range(0, counter):
					markedForDeletion.push_back([x+n, y])
			counter = 1
			counter += countElementGoing(x, y, false)
			if counter >= 3:
				for n in range(0, counter):
					markedForDeletion.push_back([x, y+n])
	for m in markedForDeletion:
		m.texture_normal = array.pick_random()
		score += 1

func countElementGoing(x, y, rightOrDown = true) -> int:
	var targetX = x+1 if rightOrDown else x
	var targetY = y+1 if !rightOrDown else y
	if getElementAtLocation(x, y) == null or getElementAtLocation(targetX, targetY) == null:
		return 0
	if getElementAtLocation(x, y).texture_normal == getElementAtLocation(x+1, y).texture_normal:
		return countElementGoing(targetX, targetY, rightOrDown) + 1
	return 0
	
func getElementAtLocation(x, y):
	if x < 0 or x > sizeX or y < 0 or y > sizeY:
		return null
	var index = y*sizeX + x
	if index < grid_container.get_child_count():
		return grid_container.get_child(index)
	return null
