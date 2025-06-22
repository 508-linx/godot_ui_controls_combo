@tool
extends 'res://addons/ui_controls_combo/menu_base.gd'

signal combo_signal_option_changed(idx);

enum NODE_IDX { BTN }

@export_category('Setting')
@export var loop_selection := false;
@export var allow_vertical_control := true;
@export var allow_horizontal_control := false;

@export_group('State')
@export var combo_option_selected := 0:
	set(new_state):
		combo_option_selected = new_state;
		__update_button();

@export_group('Node')
@export var node_button: OptionButton:
	set(new_value):
		node_button = new_value;
		__check_node( node_button, NODE_IDX.BTN, OptionButton, __select_option );
		update_configuration_warnings();

func _get_configuration_warnings():
	if !is_instance_valid( assigned_node[ NODE_IDX.BTN ] ):
		return ['Please ASSIGN [ node_button ] to make this node WORK'];

func __update_button():
	if is_instance_valid( assigned_node[ NODE_IDX.BTN ] ):
		assigned_node[ NODE_IDX.BTN ].selected = combo_option_selected;
	if !block_emit_signal and not Engine.is_editor_hint():
		combo_signal_option_changed.emit( combo_option_selected );
	return get_instance_id();

func __select_option( new_idx := -1 ):
	if is_instance_valid( assigned_node[ NODE_IDX.BTN ] ):
		combo_option_selected = assigned_node[ NODE_IDX.BTN ].selected;

func previous_button():
	if !is_instance_valid( assigned_node[ NODE_IDX.BTN ] ): return;
	var item_size = assigned_node[ NODE_IDX.BTN ].item_count;
	var target_idx = combo_option_selected - 1;
	if loop_selection:
		combo_option_selected = ( target_idx + item_size ) % item_size;
	else:
		combo_option_selected = clamp( target_idx, 0, item_size-1 );

func next_button():
	if !is_instance_valid( assigned_node[ NODE_IDX.BTN ] ): return;
	var item_size = assigned_node[ NODE_IDX.BTN ].item_count;
	var target_idx = combo_option_selected + 1;
	if loop_selection:
		combo_option_selected = target_idx % item_size;
	else:
		combo_option_selected = clamp( target_idx, 0, item_size-1 );

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
	if __is_input( event, 'ui_accept' ):		pass;
	if __is_input( event, 'ui_cancel' ):		pass;
	if __is_input( event, 'ui_up' ):			if allow_vertical_control: previous_button();
	if __is_input( event, 'ui_down' ):			if allow_vertical_control: next_button();
	if __is_input( event, 'ui_left' ):			if allow_horizontal_control: previous_button();
	if __is_input( event, 'ui_right' ):			if allow_horizontal_control: next_button();
	super._input(event);
