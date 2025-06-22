extends Node2D

# Параметры
const ITERATIONS = 3
const ANGLE = 90
const LENGTH = 10

var axiom = "F"
var rules = {"F": "F+F-F-F+F"}
var current_string = ""

func _ready():
	# Генерируем строку
	current_string = axiom
	for _i in range(ITERATIONS):
		var new_string = ""
		for char in current_string:
			new_string += rules.get(char, char)
		current_string = new_string
	
	# Рисуем
	draw_lsystem()

func draw_lsystem():
	var line = $Line2D
	line.clear_points()
	
	var pos = Vector2(100, 500) # Начальная позиция
	var dir = Vector2.RIGHT   # Начальное направление
	var angle = 0
	
	line.add_point(pos)
	
	for char in current_string:
		if char == "F":
			var new_pos = pos + dir * LENGTH
			line.add_point(new_pos)
			pos = new_pos
		elif char == "+":
			angle += ANGLE
			dir = Vector2.RIGHT.rotated(deg2rad(angle))
		elif char == "-":
			angle -= ANGLE
			dir = Vector2.RIGHT.rotated(deg2rad(angle))

func _input(event):
	if event.is_action_pressed("ui_accept"):
		# Перегенерация при нажатии Enter
		_ready()
