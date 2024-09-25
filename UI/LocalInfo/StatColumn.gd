@tool
extends VBoxContainer

@export var stat := "":
	set(value):
		stat = value
		setTooltip()

@export var icon: Texture2D:
	set(value):
		icon = value
		
		if get_node_or_null("Icon"):
			get_node_or_null("Icon").texture = value

@export_range(0, 1, 0.01) var statLevel: float:
	set(value):
		statLevel = value
		setTooltip()
		
		if get_node_or_null("Bar"):
			get_node_or_null("Bar").value = value
			get_node_or_null("Bar").tint_progress = Utils.RedYellowGreenGradient.sample(value)

func setTooltip():
	if get_node_or_null("Icon"):
		get_node_or_null("Icon").tooltip_text = stat + ": " + str(snappedf(statLevel * 100, 0.01)) + "%"

func _physics_process(delta: float) -> void:
	setTooltip()
