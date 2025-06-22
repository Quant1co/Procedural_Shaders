extends Node

# Размер сетки
const GRID_WIDTH = 50
const GRID_HEIGHT = 50
const CELL_SIZE = 10

# Массив для хранения состояний (0 - мёртвая, 1 - живая)
var grid = []

# Инициализация
func _ready():
	# Создаём пустой массив
	for x in range(GRID_WIDTH):
		var column = []
		for y in range(GRID_HEIGHT):
			column.append(0)
		grid.append(column)
	
	# Создаём ячейки
	for x in range(GRID_WIDTH):
		for y in range(GRID_HEIGHT):
			var cell = ColorRect.new()
			cell.rect_size = Vector2(CELL_SIZE, CELL_SIZE)
			cell.rect_position = Vector2(x * CELL_SIZE, y * CELL_SIZE)
			add_child(cell)
	
	# Задаём случайное начальное состояние
	randomize()
	for x in range(GRID_WIDTH):
		for y in range(GRID_HEIGHT):
			grid[x][y] = randi() % 2
			update_cell_color(x, y)
	
	# Запускаем симуляцию
	$Timer.start()

# Обновление ячейки
func update_cell_color(x, y):
	var cell = get_child(x * GRID_HEIGHT + y)
	cell.color = Color.WHITE if grid[x][y] == 1 else Color.BLACK

# Подсчёт живых соседей
func count_neighbors(x, y):
	var count = 0
	for i in range(-1, 2):
		for j in range(-1, 2):
			if i == 0 and j == 0:
				continue
			var nx = x + i
			var ny = y + j
			if nx >= 0 and nx < GRID_WIDTH and ny >= 0 and ny < GRID_HEIGHT:
				count += grid[nx][ny]
	return count

# Обновление сетки
func update_grid():
	var new_grid = grid.duplicate(true)
	for x in range(GRID_WIDTH):
		for y in range(GRID_HEIGHT):
			var neighbors = count_neighbors(x, y)
			if grid[x][y] == 1:
				if neighbors < 2 or neighbors > 3:
					new_grid[x][y] = 0
			else:
				if neighbors == 3:
					new_grid[x][y] = 1
	grid = new_grid
	for x in range(GRID_WIDTH):
		for y in range(GRID_HEIGHT):
			update_cell_color(x, y)

# Таймер для обновления
func _on_Timer_timeout():
	update_grid()
