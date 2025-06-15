@tool
extends 'res://addons/ui_controls_combo/menu_base.gd'

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

func press_button():
	if is_instance_valid( assigned_node[ NODE_IDX.BTN ] ):
		assigned_node[ NODE_IDX.BTN ].button_pressed = !assigned_node[ NODE_IDX.BTN ].button_pressed;
		__update_button();

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
	if __is_input( event, 'ui_accept' ):		press_button();
	if __is_input( event, 'ui_cancel' ):		pass;
	if __is_input( event, 'ui_up' ):			pass;
	if __is_input( event, 'ui_down' ):			pass;
	if __is_input( event, 'ui_left' ):			pass;
	if __is_input( event, 'ui_right' ):			pass; return;
	super._input(event);
