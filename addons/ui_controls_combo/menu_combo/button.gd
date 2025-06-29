@tool
class_name Editor_UiControlsCombo_Menu_Button extends Editor_UiControlsCombo_Menu

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
@export var node_button: BaseButton:
	set(new_value):
		node_button = new_value;
		__check_node( node_button, NODE_IDX.BTN, BaseButton, __click_switch );
		update_configuration_warnings();

func _get_configuration_warnings():
	if !is_instance_valid( assigned_node[ NODE_IDX.BTN ] ):
		return ['Please ASSIGN [ node_button ] to make this node WORK'];

func __update_button():
	var is_toggle_mode := false;
	if is_instance_valid( assigned_node[ NODE_IDX.BTN ] ):
		assigned_node[ NODE_IDX.BTN ].button_pressed = combo_button_pressed;
		is_toggle_mode = assigned_node[ NODE_IDX.BTN ].toggle_mode;
	if !block_emit_signal and not Engine.is_editor_hint():
		if !is_toggle_mode or combo_button_pressed:
			combo_signal_button_pressed.emit();
		if !is_toggle_mode or !combo_button_pressed:
			combo_signal_button_released.emit();
	return get_instance_id();

func __click_switch():
	if is_instance_valid( assigned_node[ NODE_IDX.BTN ] ):
		combo_button_pressed = assigned_node[ NODE_IDX.BTN ].button_pressed;

func __change_button_state( to_state = null ):
	if !__is_editable(): return;
	if to_state is bool:
		combo_button_pressed = to_state;
	elif is_instance_valid( assigned_node[ NODE_IDX.BTN ] ):
		combo_button_pressed = !assigned_node[ NODE_IDX.BTN ].button_pressed;

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
