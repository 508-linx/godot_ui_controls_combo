@tool
class_name Editor_UiControlsCombo_Menu_Slider extends Editor_UiControlsCombo_Menu

signal combo_signal_value_changed( value: float );

enum NODE_IDX { SLIDER, VALUE_LABEL, STEP_UP_BTN, STEP_DOWN_BTN }

@export_category('Setting')
@export var round_value := true;
@export var display_digi_after_decimal := 0:
	set(new_value): display_digi_after_decimal = abs(new_value);

@export_group('State')
@export var combo_value := 0.0:
	set(new_value):
		combo_value = new_value;
		__update_button();

@export_group('Node')
@export var node_slider: Slider:
	set(new_value):
		node_slider = new_value;
		__check_node( node_slider, NODE_IDX.SLIDER, Slider, __value_changed );
@export var node_step_down_button: BaseButton:
	set(new_value):
		node_step_down_button = new_value;
		__check_node( node_step_down_button, NODE_IDX.STEP_DOWN_BTN, BaseButton, step_down_value );
@export var node_step_up_button: BaseButton:
	set(new_value):
		node_step_up_button = new_value;
		__check_node( node_step_up_button, NODE_IDX.STEP_UP_BTN, BaseButton, step_up_value );
@export var node_value_label: Label:
	set(new_value):
		node_value_label = new_value;
		__check_node( node_value_label, NODE_IDX.VALUE_LABEL, Label );

func _get_configuration_warnings():
	if !is_instance_valid( assigned_node[ NODE_IDX.SLIDER ] ):
		return ['Please ASSIGN [ node_slider ] to make this node WORK'];

func __update_button():
	if is_instance_valid( assigned_node[ NODE_IDX.SLIDER ] ):
		assigned_node[ NODE_IDX.SLIDER ].value = combo_value;
	if is_instance_valid( assigned_node[ NODE_IDX.VALUE_LABEL ] ):
		if display_digi_after_decimal > 0:
			var display_format := '%.' + str( display_digi_after_decimal ) + 'f';
			if round_value:
				assigned_node[ NODE_IDX.VALUE_LABEL ].text = display_format % combo_value;
			else:
				var div = pow( 10, display_digi_after_decimal );
				var display_value: float = floor( combo_value * div ) / div;
				assigned_node[ NODE_IDX.VALUE_LABEL ].text = display_format % display_value;
		else:
			assigned_node[ NODE_IDX.VALUE_LABEL ].text = str(
					roundi( combo_value ) if round_value else floori( combo_value ) );
	if !block_emit_signal and not Engine.is_editor_hint():
		combo_signal_value_changed.emit( combo_value );
	return get_instance_id();

func __value_changed( new_value := 0.0 ):
	if is_instance_valid( assigned_node[ NODE_IDX.SLIDER ] ):
		combo_value = assigned_node[ NODE_IDX.SLIDER ].value;

func step_up_value():
	if is_instance_valid( assigned_node[ NODE_IDX.SLIDER ] ):
		assigned_node[ NODE_IDX.SLIDER ].value += assigned_node[ NODE_IDX.SLIDER ].step;
func __press_up_or_right_key( is_verticle_control := false ):
	if is_instance_valid( assigned_node[ NODE_IDX.SLIDER ] ):
		if assigned_node[ NODE_IDX.SLIDER ] is VSlider:
			if is_verticle_control: step_up_value();
		elif assigned_node[ NODE_IDX.SLIDER ] is HSlider:
			if !is_verticle_control: step_up_value();

func step_down_value():
	if is_instance_valid( assigned_node[ NODE_IDX.SLIDER ] ):
		assigned_node[ NODE_IDX.SLIDER ].value -= assigned_node[ NODE_IDX.SLIDER ].step;
func __press_down_or_left_key( is_verticle_control := false ):
	if is_instance_valid( assigned_node[ NODE_IDX.SLIDER ] ):
		if assigned_node[ NODE_IDX.SLIDER ] is VSlider:
			if is_verticle_control: step_down_value();
		elif assigned_node[ NODE_IDX.SLIDER ] is HSlider:
			if !is_verticle_control: step_down_value();

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
	if __is_input( event, 'ui_up', true ):		__press_up_or_right_key( true );
	if __is_input( event, 'ui_down', true ):	__press_down_or_left_key( true );
	if __is_input( event, 'ui_left', true ):	__press_down_or_left_key();
	if __is_input( event, 'ui_right', true ):	__press_up_or_right_key();
	super._input(event);
