extends Node

export var title: String

func GetGrowthAmount():
	return get_node("..").growthProgress

func GetTimeTillGrowth():
	var progress= GetGrowthAmount()
	var maxGrowthTime= get_node("..").timeToFullyGrow
	
	return (100 - progress) / 100.0 * maxGrowthTime

func GetPercentHealth():
	return str(round((get_node("..").health/get_node("..").maxHealth)*100))+"%"

func GetDataBodyText():
	return "Growth Amount:\n\t%s\nTotal Time To Grow:\n\t%s\nTime Left To Grow\n\t%s\nHealth:\n\t%s\n" % [round(GetGrowthAmount()), get_node("..").timeToFullyGrow,round(GetTimeTillGrowth()),GetPercentHealth()]

func GetTexture():
	return get_parent().frames.get_frame("default", get_parent().frame);
