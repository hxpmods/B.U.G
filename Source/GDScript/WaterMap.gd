extends TileMap

export var chance = 0.01


func process_drops():
	for cell in get_used_cells():
		if randf() < 0.01:
			var curr = Currency.new()
			curr.name = "Gold"
			curr.amount = 5
			var p = GameManager.PickupManager.CreateFromCurrency(curr,cell*cell_size.x + cell_size*0.5)
			p.remove_from_group("harvestable")
			p.add_to_group("fishable")
			
func _on_Timer_timeout():
	process_drops()
