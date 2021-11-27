extends Position2D

export var radius : float

func _draw():
	var col = Color.green
	col.a = 0.2
	draw_circle(Vector2.ZERO, radius,col)
