@tool
extends 'res://addons/ui_controls_combo/menu_base.gd'

signal combo_signal_button_pressed;
signal combo_signal_button_released;
signal combo_signal_switch_changed(state);

enum NODE_IDX { SWITCH, TRUE_BTN, FALSE_BTN }

@export_category('Setting')
@export_group('State')
@export var combo_button_pressed := false:
	set(new_state):
		combo_button_pressed = new_state;
		__update_button();

@export_group('Node')
@export var node_switch: CheckButton:
	set(new_value):
		node_switch = new_value;
		__check_node( node_switch, NODE_IDX.SWITCH, BaseButton, __click_switch );
@export var node_true_button: BaseButton:
	set(new_value):
		node_true_button = new_value;
		__check_node( node_true_button, NODE_IDX.TRUE_BTN, BaseButton, press_true_button );
@export var node_false_button: BaseButton:
	set(new_value):
		node_false_button = new_value;
		__check_node( node_false_button, NODE_IDX.FALSE_BTN, BaseButton, press_false_button );

func __update_button():
	if is_instance_valid( assigned_node[ NODE_IDX.SWITCH ] ):
		assigned_node[ NODE_IDX.SWITCH ].button_pressed = combo_button_pressed;
	if is_instance_valid( assigned_node[ NODE_IDX.TRUE_BTN ] ):
		assigned_node[ NODE_IDX.TRUE_BTN ].button_pressed = combo_button_pressed;
	if is_instance_valid( assigned_node[ NODE_IDX.FALSE_BTN ] ):
		assigned_node[ NODE_IDX.FALSE_BTN ].button_pressed = !combo_button_pressed;
	if !block_emit_signal and not Engine.is_editor_hint():
		if combo_button_pressed:
			combo_signal_button_pressed.emit();
		if !combo_button_pressed:
			combo_signal_button_released.emit();
		combo_signal_switch_changed.emit( combo_button_pressed );
	return get_instance_id();

func __click_switch():
	if is_instance_valid( assigned_node[ NODE_IDX.SWITCH ] ):
		combo_button_pressed = assigned_node[ NODE_IDX.SWITCH ].button_pressed;

func press_switch():
	if is_instance_valid( assigned_node[ NODE_IDX.SWITCH ] ):
		combo_button_pressed = !assigned_node[ NODE_IDX.SWITCH ].button_pressed;

func press_true_button():	combo_button_pressed = true;
func press_false_button():	combo_button_pressed = false;

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
	if __is_input( event, 'ui_accept' ):		press_switch();
	if __is_input( event, 'ui_cancel' ):		pass;
	if __is_input( event, 'ui_up' ):			pass;
	if __is_input( event, 'ui_down' ):			pass;
	if __is_input( event, 'ui_left' ):			press_false_button();
	if __is_input( event, 'ui_right' ):			press_true_button();
	super._input(event);
