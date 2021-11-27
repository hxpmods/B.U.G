extends Panel

var origPosition 
var isVisible = false
# Called when the node enters the scene tree for the first time.

func Start(data):
	
	
	if isVisible:
		yield($Tween,"tween_all_completed")
	isVisible = true;
	var offscreenPos = origPosition
	offscreenPos.y += 350
	$InfoBookContainer.data = data
	$Tween.interpolate_property(self,"rect_global_position",offscreenPos,origPosition,0.7,Tween.TRANS_ELASTIC, Tween.EASE_OUT)
	$Tween.start()
	
func End():
	if isVisible:
		if $Tween.is_active():
			yield($Tween,"tween_all_completed")
		isVisible= false;
		var offscreenPos = origPosition
		offscreenPos.y += 350
		$Tween.interpolate_property(self,"rect_global_position",origPosition,offscreenPos,0.5,Tween.TRANS_ELASTIC)
		$Tween.start()
		
		var data = $InfoBookContainer.data
		
		yield(get_tree().create_timer(0.5),"timeout")
		if $InfoBookContainer.data == data:
			$InfoBookContainer.data = null


func _on_MarginContainer_sort_children():
	origPosition = rect_global_position
	var offscreenPos = origPosition
	offscreenPos.y += 350
	rect_global_position = offscreenPos
