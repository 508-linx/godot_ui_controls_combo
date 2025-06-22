extends Node2D

var cur_count := 0;
func _process(delta):
	if cur_count != get_child_count():
		cur_count = get_child_count();
		print( 'count = ', cur_count, ' | fps = ', 1.0 / delta )
