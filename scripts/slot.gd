extends ColorRect

# Slot prefab script
# Util Functions

# References to the objects from the scene
@onready var filter_path = $Filter
@onready var debugLabel = $DebugText

# Locals
var slot_ID := -1
signal slot_clicked(slot)
var state = DataHandler.slot_states.NONE


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_background(c) -> void:
	color = c

func set_filter(color = DataHandler.slot_states.NONE):
	state = color
	match color:
		DataHandler.slot_states.NONE:
			filter_path.color = Color(0,0,0,0)
		DataHandler.slot_states.FREE:
			filter_path.color = Color(0,1,0,0.4)
	pass

func _on_filter_gui_input(event):
	if event.is_action_pressed("mouse_left"):
		emit_signal("slot_clicked", self)

func _dev_changetext(str : String):
	debugLabel.text = str;
