extends Sprite
class_name PheremoneManager

var image : Image
var imageTexture : ImageTexture

var size : Vector2 = Vector2(400,300)


func _ready():
	randomize()
	imageTexture = ImageTexture.new();
	image = Image.new();
	image.create(size.x,size.y,false,Image.FORMAT_RGBA8);
	
	var col = Color.green;
	col.a = 0;
	image.fill(col)
	
	imageTexture.create_from_image(image,0);
	texture = imageTexture


func AddPheremone(x : int, y : int,strength : float):

	image.lock()
	var oldcol = image.get_pixel(x,y)
	
	var newstrength = min(oldcol.a +strength, 0.95);
	
	var col = Color(oldcol.r,oldcol.g,oldcol.b, newstrength);

	image.set_pixel(x,y,col);
	image.unlock();
	imageTexture.create_from_image(image, 0);
	
	
func _process(delta):
	if (Input.is_mouse_button_pressed(1)):
		DrawWall(get_local_mouse_position())
		
func DrawWall(var pos: Vector2):
	image.lock()
	
	for i in range(5):
		for j in range(5):
	
			var col = image.get_pixel(pos.x-3+j,pos.y-3+i)
			col.r = 1.0;
			image.set_pixel(pos.x-3+j,pos.y-3+i, col)
	
	
	image.unlock()


func GetAverageFromRect(var position : Vector2, var size : float):
	
	image.lock();
	position.x = position.x - size*0.5
	position.y = position.y - size*0.5
	var rect = Rect2(position, Vector2(size, size))
	var sample = image.get_rect(rect)
	image.unlock();
	
	var averagePheremone = 0
	sample.lock()
	for x in range(size):
		for y in range(size):
			var col = sample.get_pixel(x,y)
			averagePheremone += col.a - col.r*2
	sample.unlock()
	
	averagePheremone /= size*size
	return averagePheremone
	
	
func GetRandomPosInRange():
		var x = randi()% int(size.x * scale.x)
		var y = randi()% int(size.y * scale.y)
		return Vector2(x,y)


func _on_Timer_timeout():
	image.lock()
	for i in range(image.get_width()):
		for x in range(image.get_height()):
			var col = image.get_pixel(i,x)
			
			col.a = max(col.a, col.a-0.05)
			col.a = 0.9 * col.a
			
			image.set_pixel(i,x, col)
	image.unlock()
	imageTexture.create_from_image(image,0);
