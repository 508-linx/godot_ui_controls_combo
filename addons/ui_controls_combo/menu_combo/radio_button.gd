@tool
class_name Editor_UiControlsCombo_Menu_RadioButton extends Editor_UiControlsCombo_Menu

signal combo_signal_radio_changed(idx);

enum NODE_IDX {}

@export_category('Setting')
@export var loop_selection := false;
@export var allow_vertical_control := false;
@export var allow_horizontal_control := true;

@export_group('State')
@export var combo_radio_idx := 0:
	set(new_value):
		combo_radio_idx = new_value;
		__update_button();

@export_group('Node')
@export var node_button: Array[BaseButton]:
	set(new_value):
		node_button = new_value;
		assigned_node.resize( node_button.size() );
		for idx in range( node_button.size() ):
			var node = node_button[idx];
			if node is BaseButton:
				node.toggle_mode = true;
				node.button_pressed = false;
			__check_node( node, idx, BaseButton, func():
					if is_instance_valid( assigned_node[ idx ] ) and combo_radio_idx != idx:
						combo_radio_idx = idx;
					);
		update_configuration_warnings();

func _get_configuration_warnings():
	var valid_count := 0;
	for node in assigned_node:
		if is_instance_valid(node): valid_count += 1;
	if valid_count <= 1:
		return ['Please ASSIGN Array[ node_button ] to make this node WORK\n* at least two to make it meaningful'];

func __update_button():
	for idx in range( assigned_node.size() ):
		if is_instance_valid( assigned_node[ idx ] ):
			assigned_node[ idx ].button_pressed = idx == combo_radio_idx;
	if !block_emit_signal and not Engine.is_editor_hint():
		combo_signal_radio_changed.emit( combo_radio_idx );
	return get_instance_id();

func previous_button():
	var target_idx = combo_radio_idx - 1;
	if loop_selection:
		combo_radio_idx = ( target_idx + assigned_node.size() ) % assigned_node.size();
	else:
		combo_radio_idx = clamp( target_idx, 0, assigned_node.size()-1 );

func next_button():
	var target_idx = combo_radio_idx + 1;
	if loop_selection:
		combo_radio_idx = target_idx % assigned_node.size();
	else:
		combo_radio_idx = clamp( target_idx, 0, assigned_node.size()-1 );

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
