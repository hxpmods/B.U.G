extends Sprite

var resource :Currency
var pickedUp = false

func SetResource(var res : Currency):
	resource= res
	texture = GameManager.ResourceManager.get_node(res.name).texture
	$Particles2D.texture = texture

func _on_Body_Selected(entity):
	if !pickedUp:
		get_tree().set_input_as_handled()
	PickUp()
	

func PickUp():
	if !pickedUp:
		
		pickedUp = true
		GameManager.ResourceManager.AddResource(resource.name,resource.amount)
		$Particles2D.emitting = true
		GameManager.AudioManager.PlayPickup()
		texture = null
		yield(get_tree().create_timer(0.8),"timeout")
		$Particles2D.emitting = false
		queue_free()
