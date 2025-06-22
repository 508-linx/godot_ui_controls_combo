extends Node2D

@export var indicator_node: Node2D;

const pos_rand_fix := 1.5;
const speed_fix := 0.1;
var velocity := Vector2.ZERO;
func _process(delta):
	var center := Vector2(
		ProjectSettings.get_setting('display/window/size/viewport_width'),
		ProjectSettings.get_setting('display/window/size/viewport_height'),
	) * 0.5;
	var pos_rand := center.length() * pos_rand_fix;
	var offset := center - global_position;
	var target_pos := offset + Vector2( randf() - 0.5, randf() - 0.5 ) * pos_rand;
	var sim := target_pos.normalized().dot( velocity.normalized() );
	var sim_fix := 1.0 - ( sim + 1.0 ) * 0.25;
	velocity = lerp( velocity, target_pos, delta * speed_fix * sim_fix );
	global_position += velocity;
	
	if indicator_node == null:
		indicator_node = get_node('NONcombo_ResourceIndicator');
	else:
		indicator_node.global_position = global_position;
	## NOTE: this use getter func to call redraw
	for idx in range( indicator_node.display_value.size() ):
		var item = indicator_node.display_value[ idx ];
		indicator_node.display_value[ idx ].x = fmod( item.x + delta * 10.0, item.y );
	## NOTE: or use this to call redraw while you turn off [ getter_redraw ]
	# indicator_node.queue_redraw();
	## NOTE: also you can reassign value like this, are this code stupid?
	# indicator_node.display_value = indicator_node.display_value;
	
	## NOTE: little heavy if you update indicator with text every frame
