@tool
extends Control

# NOTE:
#   for focusing, selecting
#   do not handle focus move here, only provide method for select and change value
#   why? because I want to made input can select and change multi node

@export_category('Setting')
@export_group('Config')
@export var disabled := false:
	set(new_value):
		disabled = new_value;
@export var selecting := false:
	set(new_state):
		selecting = new_state;
		__change_selecting_state();

@export_group('Selection')
@export var blinkable_node: Array[Control];
@export var selection_on_front := true:
	set(new_value):
		selection_on_front = new_value;
		__change_selection_order();
@export var selection_color := Color( 1.0, 1.0, 1.0, 0.5 );

var blink_timer := 0.0;

func __sync_node( node: Control ):
	if node.get('disabled') != null:
		node.disabled = disabled;
	for child_node in node.get_children():
		__sync_node( child_node );

func __change_selection_order():
	move_child( get_node('menu_selection'), get_child_count()-1 if selection_on_front else 0 );
func __change_selecting_state():
	__sync_node( $'.' );
	get_node('menu_selection').modulate.a = selection_color.a if selecting else 0.0;
	#_MAIN.PA.queue_smooth_update( selection_node, selection_modulate_alpha if is_selecting else 0.0, 'modulate', 'a' );

func __create_selection():
	var new_node := ColorRect.new();
	new_node.name = 'menu_selection';
	new_node.visible = true;
	new_node.set_anchors_and_offsets_preset( Control.PRESET_FULL_RECT );
	new_node.mouse_default_cursor_shape = Control.CURSOR_ARROW;
	new_node.mouse_filter = Control.MOUSE_FILTER_IGNORE;
	new_node.modulate = selection_color;
	add_child( new_node );
	__change_selection_order();
	__change_selecting_state();

func _ready():
	focus_entered.connect( func(): selecting = true );
	focus_exited.connect( func(): selecting = false );
	__create_selection();

func value_step_next( step := 1 ): pass
func value_step_back( step := 1 ): pass
