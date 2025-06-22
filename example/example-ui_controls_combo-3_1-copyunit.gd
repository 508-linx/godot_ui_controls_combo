extends "res://example/example-ui_controls_combo-3-extra_body.gd"

## perfomance test unit, becareful your computer burnout
@export var copy_time := 10.0;

var counter := 0.0;
func _process(delta):
	counter += delta;
	if counter > copy_time:
		counter -= copy_time;
		var new_node = duplicate();
		get_parent().add_child(new_node);
	super._process(delta);
