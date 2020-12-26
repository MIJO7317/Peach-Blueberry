class_name Matrix

var matrix = [] setget get, set;

func _init(size := Vector2(0,0)):
	for i in range(size.x):
		matrix.append([]);
		for j in range(size.y):
			matrix[i].append(0);

func get(i = 0, j = 0) -> int:
	return matrix[i][j];

func set(i = 0, j = 0, value = 0):
	matrix[i][j] = value;

func clear():
	for i in range(matrix.size()):
		for j in range(matrix[i].size()):
			matrix[i][j] = 0;

