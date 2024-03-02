extends TextureButton
class_name ColorNodeButton

const DEFAULT = preload("res://resources/default.tres")
var colorNode

func _init(n: ColorNode):
	setColor(n)
	stretch_mode = TextureButton.STRETCH_SCALE
	size_flags_horizontal = 6

func setColor(n: ColorNode):
	if n:
		texture_normal = n.resource
	else:
		texture_normal = DEFAULT
	colorNode = n
