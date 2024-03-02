extends MarginContainer

@onready var grid_container = $GridContainer

const moveDelay = 0.2
const sizeX = 5
const sizeY = 5
var array: Array[Array]
var lastSelected
var score = 0

func _ready():
	for child in grid_container.get_children():
		child.queue_free()
	grid_container.columns = sizeX
	
	for i in range(0, sizeX):
		var arr = []
		for y in range(0, sizeY):
			arr.push_back(ColorNode.getRandom())
		array.push_back(arr)
	updateDisplay()
	printArray()
	
func updateDisplay():
	for c in grid_container.get_children():
		c.queue_free()
	for arr in array:
		var vBox: VBoxContainer = VBoxContainer.new()
		vBox.size_flags_horizontal = 6
		grid_container.add_child(vBox)
		for n in arr:
			vBox.add_child(getRec(n))

func getRec(n:ColorNode) -> ColorNodeButton:
	var newRec:ColorNodeButton = ColorNodeButton.new(n)
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

func switchTwoElements(first: ColorNodeButton, second: ColorNodeButton):
	var firstX = first.get_parent().get_index()
	var firstY = first.get_index()
	var secondX = second.get_parent().get_index()
	var secondY = second.get_index()
	exchangeTwoElements(Vector2(firstX, firstY), Vector2(secondX, secondY))
	
func checkForMatches():
	var markedForDeletion: Array[Vector2] = []
	for x in range(0, sizeX):
		for y in range(0, sizeY):
			var counter = 1
			counter += countElementGoing(x, y, true)
			if counter >= 3:
				for n in range(0, counter):
					markedForDeletion.push_back(Vector2(x+n, y))
			counter = 1
			counter += countElementGoing(x, y, false)
			if counter >= 3:
				for n in range(0, counter):
					markedForDeletion.push_back(Vector2(x, y+n))
	for v in markedForDeletion:
		getDisplayNodeByCoordinate(v).setColor(null)
		array[v.x][v.y] = null
		score += 1
	if markedForDeletion.size() > 0:
		var nothingMoved = false
		while nothingMoved == false:
			nothingMoved = true
			for x in range(0,array.size(),  1):
				for y in range( 0,array[x].size(), 1):
					if y+1 < array[x].size() && getElementAtLocation(x, y+1) == null && getElementAtLocation(x, y) != null:
						var newPosition = y+1
						for currentY in range(y+1, array[x].size()):
							if getElementAtLocation(x, currentY+1) == null:
								newPosition = currentY
							else:
								break
						print(str(x) + "-" + str(y) +"<=>" + str(x) + "-" + str(newPosition))
						exchangeTwoElements(Vector2(x, y), Vector2(x, newPosition))
						nothingMoved = false
		"""
		for x in range(0,array.size(),  1):
			for y in range( 0,array[x].size(), 1):
				if getElementAtLocation(x, y) == null:
					getElementAtLocation(x, y).set
		"""
		checkForMatches()

func countElementGoing(x, y, rightOrDown = true) -> int:
	var targetX = x+1 if rightOrDown else x
	var targetY = y+1 if !rightOrDown else y
	if getElementAtLocation(x, y) == null or getElementAtLocation(targetX, targetY) == null:
		return 0
	if getElementAtLocation(x, y).color == getElementAtLocation(targetX, targetY).color:
		return countElementGoing(targetX, targetY, rightOrDown) + 1
	return 0
	
func getElementAtLocation(x, y) -> ColorNode:
	if x < 0 or x > sizeX-1 or y < 0 or y > sizeY-1:
		return null
	return array[x][y]

func printArray():
	for y in range(0, sizeY):
		var s = ""
		for x in range(0, sizeX):
			s += ColorNode.getColorFromEnum(array[x][y])
		print(s)
	print('=====')

func getDisplayNodeByCoordinate(vec: Vector2)-> ColorNodeButton:
	return grid_container.get_child(vec.x).get_child(vec.y)

func exchangeTwoElements(origin: Vector2, target: Vector2):
	if origin == target:
		print("Mmmh what?")
		return
	var tempFirst = array[origin.x][origin.y]
	array[origin.x][origin.y] = array[target.x][target.y]
	array[target.x][target.y] = tempFirst
	printArray()
	
func moveAllButtonsToTheirLocation():
	for xBox in grid_container.get_children():
		for yBox in x.get_children():
			var node = getDisplayNodeByCoordinate(xBox.get_index(), yBox.get_index())
			if node.colorNode != null:
				var correspondingLocation
				for x in range(0, array.size()):
					for y in range(0, array[x].size()):
						if array[x][y] == 
