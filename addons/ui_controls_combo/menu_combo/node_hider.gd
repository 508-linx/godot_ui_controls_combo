@tool
class_name Editor_UiControlsCombo_Menu_NodeHider extends Editor_UiControlsCombo_Menu

signal combo_signal_button_pressed;
signal combo_signal_button_released;

enum NODE_IDX { BTN }

@export_category('Setting')
@export_group('State')
@export var combo_button_pressed := false:
	set(new_state):
		combo_button_pressed = new_state;
		__update_button();

@export_group('Node')
@export var node_show_pressed: Array[Node]:
	set(new_value):
		node_show_pressed = new_value;
		update_configuration_warnings();
@export var node_show_released: Array[Node]:
	set(new_value):
		node_show_released = new_value;
		update_configuration_warnings();

func _get_configuration_warnings():
	if node_show_pressed.size() == 0 and node_show_released.size() == 0:
		return ['Please ASSIGN any node to make this node meaningful'];

func __update_button():
	if is_instance_valid( assigned_node[ NODE_IDX.BTN ] ):
		assigned_node[ NODE_IDX.BTN ].button_pressed = combo_button_pressed;
		for node in node_show_pressed:
			if !is_instance_valid(node): continue;
			node.visible = combo_button_pressed;
		for node in node_show_released:
			if !is_instance_valid(node): continue;
			node.visible = !combo_button_pressed;
		
	if !block_emit_signal and not Engine.is_editor_hint():
		if combo_button_pressed:
			combo_signal_button_pressed.emit();
		else:
			combo_signal_button_released.emit();
	return get_instance_id();

func __click_switch():
	if is_instance_valid( assigned_node[ NODE_IDX.BTN ] ):
		combo_button_pressed = assigned_node[ NODE_IDX.BTN ].button_pressed;

func __change_button_state( to_state = null ):
	if !__is_editable(): return;
	if to_state is bool:
		combo_button_pressed = to_state;
	else:
		combo_button_pressed = !combo_button_pressed;

## set combo_button_pressed to invert assigned node_button property button_pressed, than update combo
## nothing occur while haven't Node assigned
func click_button():	__change_button_state();
## change combo_button_pressed to true than update combo
func press_button():	__change_button_state( true );
## change combo_button_pressed to false than update combo
func release_button():	__change_button_state( false );

#
# engine call relate
#

func _init():
	assigned_node.resize( NODE_IDX.size() );

func _ready():
	var new_btn := Button.new();
	new_btn.name = 'cover_btn';
	new_btn.focus_mode = Control.FOCUS_CLICK;
	new_btn.mouse_filter = Control.MOUSE_FILTER_STOP;
	new_btn.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND;
	new_btn.set_anchors_and_offsets_preset( Control.PRESET_FULL_RECT );
	var empty_bos := StyleBoxEmpty.new();
	new_btn.add_theme_stylebox_override( 'focus', empty_bos );
	new_btn.add_theme_stylebox_override( 'normal', empty_bos );
	new_btn.add_theme_stylebox_override( 'hover', empty_bos );
	new_btn.add_theme_stylebox_override( 'pressed', empty_bos );
	new_btn.toggle_mode = true;
	new_btn.pressed.connect( __click_switch );
	add_child( new_btn );
	assigned_node[ NODE_IDX.BTN ] = new_btn;
	
	block_emit_signal = true;
	__update_button();
	block_emit_signal = false;
	super._ready();

func _input(event):
	if !use_godot_input: return;
	if __is_input( event, 'ui_accept' ):		click_button();
	if __is_input( event, 'ui_cancel' ):		pass;
	if __is_input( event, 'ui_up' ):			pass;
	if __is_input( event, 'ui_down' ):			pass;
	if __is_input( event, 'ui_left' ):			pass;
	if __is_input( event, 'ui_right' ):			pass;
	super._input(event);
