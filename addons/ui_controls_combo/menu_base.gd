@tool
class_name Editor_UiControlsCombo_Menu extends Editor_UiControlsCombo_Base

# WARNING:
#   [ Godot 4.3 ]
#   while copy and paste menu node with signal connected (it occur on non-script connect signal only)
#   an error 'scene/main/node.cpp:2192 - Parameter "common_parent" is null.' popup
#   this is an godot error because this occur on other Node, not only menu node
#   but this error have nothing effect, so ignore it

signal combo_grab_focus;
signal combo_release_focus;
signal combo_selecting;
signal combo_unselecting;

@export_category('Setting')
## this node auto update size on resize self, child enter or exit. you can use this button while you update some child parameter but this node haven't resize.
@export var force_resize := false:
	set(x): __set_size();
## use this if you change and child mouse filter after added child into tree
@export var force_check_child_mouse_filter := false:
	set(x): __check_child_mouse_filter();

@export_group('State')
## turn this on/off make all child has disabled sync, addictionally apply modulate_disabled to node in color list
@export var is_disabled := false:
	set(new_value):
		is_disabled = new_value;
		__sync_node( $'.' );
## focusing is state you CAN NOT change data inside until you turn on selecting, only one menu combo can focusing
## also EQUAL to mouse hovering, and mouse click ignore is_selecting state
@export var is_focusing := false:
	set(new_state):
		is_focusing = new_state;
		
		if !block_emit_signal and not Engine.is_editor_hint():
			if is_focusing:		combo_grab_focus.emit();
			else:				combo_release_focus.emit();
		
		if !stop_sync and sync_focusing:
			stop_sync = true;
			is_selecting = new_state;
			stop_sync = false;
		if is_inside_tree() and use_godot_input and not Engine.is_editor_hint():
			if new_state:	grab_focus();
			else:			release_focus();
## selecting is state you CAN change data inside, you can select multi menu combo and change them on same time
@export var is_selecting := false:
	set(new_state):
		is_selecting = new_state;
		
		if !block_emit_signal and not Engine.is_editor_hint():
			if is_selecting:	combo_selecting.emit();
			else:				combo_unselecting.emit();
		
		if !stop_sync and sync_focusing:
			stop_sync = true;
			is_focusing = new_state;
			stop_sync = false;
## auto sync is_selecting while is_focusing changed
@export var sync_focusing := true:
	set(new_state):
		sync_focusing = new_state;
		if sync_focusing: is_selecting = is_focusing;
## use this for stop sync state to protect recursive call of is_focusing and is_selecting
var stop_sync := false;

@export_group('Display')
@export var selection_texture: Texture2D:
	set(new_texture):
		selection_texture = new_texture;
		__create_selection();
@export var selection_margin := Vector4i.ZERO:
	set(new_value):
		selection_margin = new_value;
		__reset_selection_margin_value();
@export var selection_on_top := true:
	set(new_state):
		selection_on_top = new_state;
		__reorder_selection();
@export var normal_modulate := Color.TRANSPARENT;
@export var focusing_modulate := Color( 1.0, 1.0, 1.0, 0.5 );
@export var focusing_blinking := true;
@export var focusing_time := 0.7;
@export var selecting_modulate := Color( 0.4, 1.0, 0.6, 0.5 );
@export var selecting_blinking := false;
@export var selecting_time := 0.3;
@export_range( 0.0, 1.0 ) var focusing_selecting_mix := 0.8;
@export var disabled_modulate := Color( 0.0, 0.0, 0.0, 0.5 );
@export var disabled_blinking := false;
@export var disabled_time := 0.1;

@export_group('Config')
@export var grab_focus_on_start := false;
@export var auto_update_custom_minimum_size := false;
@export var auto_remove_focus_style := true;
@export var auto_change_mouse_cursor := true;

@export_group('Input')
## # enable to use build-in grap focus,
## you can add SHIFT mod to ui_up / ui_down / ui_left / ui_right to allow more function available on this addons combo.
## # build-in focus have some unexpected habit while using same key/button to move / change state
## ( e.g. only up-down to change node and change value with left-right but it skip to other node while have node on left/right,
## there have some method to avoid this situation but you can just disable it and control this node by calling func )
## ** DO NOT SET NEIGHBOR TO CHILD NODE WHEN YOU ENABLE THIS, IT CAUSE UNEXPECTED HABIT **
@export var use_godot_input := true:
	set(new_state):
		use_godot_input = new_state;
		__focus_setting_changed();

var block_emit_signal := false;
var focus_timer := 1.0;

#
# node creation / control
#

func __sync_node( node: Control ):
	if node.get('disabled') != null:
		node.disabled = is_disabled;
	for child_node in node.get_children():
		__sync_node( child_node );

func __reorder_selection():
	if has_node( 'area_margin' ):
		var node: MarginContainer = get_node( 'area_margin' );
		move_child( node, 0 );
	if has_node( 'selection_margin' ):
		var node: MarginContainer = get_node( 'selection_margin' );
		move_child( node, -1 if selection_on_top else 1 );

func __assign_margin( margin_node: MarginContainer ):
	margin_node.add_theme_constant_override( 'margin_left', selection_margin.x )
	margin_node.add_theme_constant_override( 'margin_top', selection_margin.y )
	margin_node.add_theme_constant_override( 'margin_right', selection_margin.z )
	margin_node.add_theme_constant_override( 'margin_bottom', selection_margin.w )
func __reset_selection_margin_value():
	if has_node( 'area_margin' ): __assign_margin( get_node( 'area_margin' ) );
	if has_node( 'selection_margin' ): __assign_margin( get_node( 'selection_margin' ) );

func __create_margin() -> MarginContainer:
	var margin_node := MarginContainer.new();
	margin_node.set_anchors_and_offsets_preset( Control.PRESET_FULL_RECT );
	margin_node.mouse_default_cursor_shape = Control.CURSOR_ARROW;
	margin_node.mouse_filter = Control.MOUSE_FILTER_IGNORE;
	margin_node.focus_mode = Control.FOCUS_NONE;
	add_child( margin_node );
	return margin_node;

func __create_selection():
	if !has_node( 'area_margin' ):
		__create_margin().name = 'area_margin';
		__reset_selection_margin_value();
	if !has_node( 'detect_area' ):
		var new_node := Control.new();
		new_node.name = 'detect_area';
		new_node.set_anchors_and_offsets_preset( Control.PRESET_FULL_RECT );
		new_node.mouse_default_cursor_shape = Control.CURSOR_ARROW;
		new_node.mouse_filter = Control.MOUSE_FILTER_STOP;
		new_node.focus_mode = Control.FOCUS_NONE;
		__assign_connection( new_node );
		get_node( 'area_margin' ).add_child( new_node );
	
	if !has_node( 'selection_margin' ):
		__create_margin().name = 'selection_margin';
		__reset_selection_margin_value();
	var margin_node: MarginContainer = get_node( 'selection_margin' );
	var use_txtrect := selection_texture != null;
	var cur_node := margin_node.get_node( 'selection' ) if margin_node.has_node( 'selection' ) else null;
	if ( cur_node is ColorRect ) if use_txtrect else ( cur_node is TextureRect ):
		margin_node.remove_child( cur_node );
		cur_node.queue_free();
		cur_node = null;
	if cur_node == null:
		if use_txtrect:
			var new_node := TextureRect.new();
			new_node.name = 'selection';
			new_node.expand_mode = TextureRect.EXPAND_IGNORE_SIZE;
			new_node.stretch_mode = TextureRect.STRETCH_SCALE;
			new_node.set_anchors_and_offsets_preset( Control.PRESET_FULL_RECT );
			new_node.mouse_default_cursor_shape = Control.CURSOR_ARROW;
			new_node.mouse_filter = Control.MOUSE_FILTER_IGNORE;
			new_node.focus_mode = Control.FOCUS_NONE;
			new_node.texture = selection_texture;
			margin_node.add_child( new_node );
		else:
			var new_node := ColorRect.new();
			new_node.name = 'selection';
			new_node.set_anchors_and_offsets_preset( Control.PRESET_FULL_RECT );
			new_node.mouse_default_cursor_shape = Control.CURSOR_ARROW;
			new_node.mouse_filter = Control.MOUSE_FILTER_IGNORE;
			new_node.focus_mode = Control.FOCUS_NONE;
			new_node.color = Color.WHITE;
			margin_node.add_child( new_node );
	__reorder_selection();

## apply combo modulate setting to target node
## also can apply calculated modulate by input setting
func set_node_modulate( node: Control, timer = null, normal_color = null, target_color = null, blinking = null, change_time = null ):
	if typeof( timer ) != TYPE_FLOAT:			timer = focus_timer;
	if typeof( normal_color ) != TYPE_COLOR:	normal_color = normal_modulate;
	if typeof( target_color ) != TYPE_COLOR:	target_color = __cur_color();
	if typeof( blinking ) != TYPE_BOOL:			blinking = __cur_blink();
	if typeof( change_time ) != TYPE_FLOAT:		change_time = __cur_change();
	
	var t := 0.0;
	if blinking:
		t = 1.0 - abs( ( fmod( timer, change_time * 2.0 ) / change_time ) - 1.0 );
	else:
		t = ( clamp( timer, 0.0, change_time ) / change_time );
	node.modulate = normal_color * (1-t) + target_color * t;

#
# interface for node register
#

var assigned_node := [];

func __check_node( new_node: Control, node_idx: int, target_class, interact_func = null ):
	if is_instance_valid( new_node ):
		block_emit_signal = true;
		if target_class == BaseButton or target_class == OptionButton:
			if assigned_node[ node_idx ] != null and assigned_node[ node_idx ] != new_node:
				__release_connected_signal( assigned_node[ node_idx ].pressed );
			if auto_remove_focus_style:
				new_node.add_theme_stylebox_override( 'focus', StyleBoxEmpty.new() );
			if auto_change_mouse_cursor:
				new_node.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND;
		elif target_class == Slider:
			if assigned_node[ node_idx ] != null and assigned_node[ node_idx ] != new_node:
				__release_connected_signal( assigned_node[ node_idx ].value_changed );
			if auto_remove_focus_style:
				new_node.add_theme_stylebox_override( 'focus', StyleBoxEmpty.new() );
			if auto_change_mouse_cursor:
				new_node.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND;
		elif target_class == Label:
			new_node.focus_mode = Control.FOCUS_NONE;
			new_node.mouse_filter = Control.MOUSE_FILTER_IGNORE;
			if auto_change_mouse_cursor:
				new_node.mouse_default_cursor_shape = Control.CURSOR_ARROW;
		block_emit_signal = false;
		
		var target_signal: Signal;
		if target_class == OptionButton:
			target_signal = new_node.item_selected;
		elif target_class == BaseButton:
			target_signal = new_node.pressed;
		elif target_class == Slider:
			target_signal = new_node.value_changed;
		
		if target_signal != null and interact_func is Callable:
			block_emit_signal = true;
			__connect_func_to_signal( target_signal, func( fake = null ):
					new_node.release_focus();
					grab_combo_focus();
					return interact_func.call() );
			block_emit_signal = false;
		assigned_node[ node_idx ] = new_node;
		
	elif assigned_node[ node_idx ] != null:
		if assigned_node[ node_idx ] is BaseButton:
			__release_connected_signal( assigned_node[ node_idx ].pressed );
		elif assigned_node[ node_idx ] is Slider:
			__release_connected_signal( assigned_node[ node_idx ].value_changed );
		assigned_node[ node_idx ] = null;

#
# some calculation
#

func __cur_color() -> Color:
	var color := normal_modulate;
	if is_disabled:
		color = disabled_modulate;
	elif is_selecting and is_focusing:
		color = selecting_modulate * focusing_selecting_mix;
		color += focusing_modulate * (1.0-focusing_selecting_mix);
	elif is_selecting:
		color = selecting_modulate;
	elif is_focusing:
		color = focusing_modulate;
	return color;

func __cur_blink() -> bool:
	var blinking := false;
	if is_disabled:		blinking = blinking or disabled_blinking;
	if is_selecting:	blinking = blinking or selecting_blinking;
	if is_focusing:		blinking = blinking or focusing_blinking;
	return blinking;

func __cur_change() -> float:
	var change_time := 0.1;
	if is_disabled:
		change_time = disabled_time;
	elif is_selecting and is_focusing:
		change_time = selecting_time * focusing_selecting_mix;
		change_time += focusing_time * (1.0-focusing_selecting_mix);
	elif is_selecting:
		change_time = selecting_time;
	elif is_focusing:
		change_time = focusing_time;
	return change_time;

#
# focus control
#

## all child node should not have focus_mode receive key focus
func __change_child_focus( node: Control, ignore_self := false ):
	if !ignore_self and node.focus_mode == Control.FOCUS_ALL:
		node.focus_mode = Control.FOCUS_CLICK
	for child_node in node.get_children():
		__change_child_focus( child_node );

func __focus_setting_changed():
	if use_godot_input:
		__connect_func_to_signal( focus_entered, func(): grab_combo_focus( Input.is_key_pressed(KEY_SHIFT) ); return get_instance_id() );
		__connect_func_to_signal( focus_exited, func(): release_combo_focus( Input.is_key_pressed(KEY_SHIFT) ); return get_instance_id() );
		focus_mode = FocusMode.FOCUS_ALL;
	else:
		__release_connected_signal( focus_entered );
		__release_connected_signal( focus_exited );
		focus_mode = FocusMode.FOCUS_NONE;

func __is_editable() -> bool:
	return !is_disabled and visible and is_selecting;
func __check_focusable() -> bool:
	return is_disabled or !is_focusing;
func __focus_neighbor_child( direct ):
	var p = get_parent();
	var idx := p.get_children().find( $'.' );
	if idx + direct < 0 or idx + direct >= p.get_child_count():
		pass # TODO: check p have setting to switch parent
	var checking_idx;
	while checking_idx != idx:
		if checking_idx == null: checking_idx = idx;
		checking_idx += direct + p.get_child_count();
		checking_idx %= p.get_child_count();
		var target_node = p.get_child( checking_idx );
		if target_node is Editor_UiControlsCombo_Menu:
			change_focus( target_node, Input.is_key_pressed(KEY_SHIFT) );
			break;

## change focus to before Editor_UiControlsCombo_Menu under same parent, loop inside parent Node
## NOTE/TODO: will add option to change focus to other parent
func focus_back_node():
	if __check_focusable(): return;
	__focus_neighbor_child( -1 );
## change focus to next Editor_UiControlsCombo_Menu under same parent, loop inside parent Node
## NOTE/TODO: will add option to change focus to other parent
func focus_next_node():
	if __check_focusable(): return;
	__focus_neighbor_child( 1 );

func __check_any_neighbor_is_selecting() -> bool:
	var any_neighbor_is_selecting := false;
	for node in [
		find_valid_focus_neighbor(SIDE_TOP),
		find_valid_focus_neighbor(SIDE_BOTTOM),
		find_valid_focus_neighbor(SIDE_LEFT),
		find_valid_focus_neighbor(SIDE_RIGHT)
	]:
		if node != null and node.get('is_selecting') != null and node.is_selecting:
			any_neighbor_is_selecting = true;
			break;
	return any_neighbor_is_selecting;
func __release_all_neighbor_is_selecting():
	for node in [
		find_valid_focus_neighbor(SIDE_TOP),
		find_valid_focus_neighbor(SIDE_BOTTOM),
		find_valid_focus_neighbor(SIDE_LEFT),
		find_valid_focus_neighbor(SIDE_RIGHT)
	]:
		if node != null and node.get('is_selecting') != null and node.is_selecting:
			node.release_combo_focus();

## change is_focusing to true while NOT disabled
## while add_selection is true + is_selecting is false,
## check any neighbor is_selecting equal true than change is_selecting to true
## skip this check while sync_focusing is true, because is_selecting already sync with is_focusing while this property is true
func grab_combo_focus( add_selection := false ):
	if is_disabled: return;
	is_focusing = true;
	if add_selection and !sync_focusing and !is_selecting and __check_any_neighbor_is_selecting():
		is_selecting = true;

## change is_focusing to false while NOT disabled
## while add_selection is false + is_selecting is true,
## change is_selecting to false and release all neighbor is_selecting  
func release_combo_focus( add_selection := false ):
	if is_disabled: return;
	is_focusing = false;
	if !add_selection and is_selecting:
		is_selecting = false;
		__release_all_neighbor_is_selecting();

## change focus to target node, only work while is_focusing equal true
func change_focus( target_node, add_selection := false ):
	if __check_focusable(): return;
	if target_node is Editor_UiControlsCombo_Menu:
		is_focusing = false;
		target_node.is_focusing = true;

#
# mouse hover / focus
#

var mouse_interact_dict := {};

func __assign_connection( node: Node ):
	if node is Control:
		if node.mouse_filter == Control.MOUSE_FILTER_IGNORE: return;
		mouse_interact_dict[ node.get_instance_id() ] = false;
		__connect_func_to_signal( node.mouse_entered,
				func(): on_mouse_enter_combo(node); return get_instance_id() );
		__connect_func_to_signal( node.mouse_exited,
				func(): on_mouse_exit_combo(node); return get_instance_id() );

func __remove_connection( node: Node ):
	if node is Control:
		if node.mouse_filter == Control.MOUSE_FILTER_IGNORE: return;
		if mouse_interact_dict.has( node.get_instance_id() ):
			mouse_interact_dict.erase( node.get_instance_id() );
		__release_connected_signal( node.mouse_entered );
		__release_connected_signal( node.mouse_exited );

func __deep_assign_connection( node: Node, remove_list ):
	__assign_connection( node );
	for child_node in node.get_children():
		if remove_list.find( child_node.get_instance_id() ) >= 0:
			remove_list.erase( child_node.get_instance_id() );
		__deep_assign_connection( child_node, remove_list );
func __check_child_mouse_filter():
	var remove_list := mouse_interact_dict.keys();
	__deep_assign_connection( $'.', remove_list )
	for key in remove_list:
		mouse_interact_dict.erase( key );

func __check_hovering():
	var any_hover := false;
	for state in mouse_interact_dict.values():
		any_hover = any_hover or state;
	if any_hover:	grab_combo_focus();
	else:			release_combo_focus();

func on_mouse_enter_combo( node: Node ):
	mouse_interact_dict[ node.get_instance_id() ] = true;
	__check_hovering();

func on_mouse_exit_combo( node: Node ):
	mouse_interact_dict[ node.get_instance_id() ] = false;
	__check_hovering();

#
# engine call relate
#

func _ready():
	mouse_default_cursor_shape = Control.CURSOR_ARROW;
	mouse_filter = Control.MOUSE_FILTER_IGNORE;
	focus_mode = Control.FOCUS_NONE;
	__create_selection();
	minimum_size_changed.connect( func():
			if auto_update_custom_minimum_size:
				__minimum_size_changed( __set_size );
			else:
				__set_size( false );
			);
	resized.connect( func(): __set_size( auto_update_custom_minimum_size ) );
	child_entered_tree.connect( func(node):
			__set_size( auto_update_custom_minimum_size );
			__assign_connection( node );
			__change_child_focus( $'.', true );
			);
	child_exiting_tree.connect( func(node):
			__set_size( auto_update_custom_minimum_size );
			__remove_connection( node );
			__change_child_focus( $'.', true );
			);
	
	__check_child_mouse_filter();
	__focus_setting_changed();
	__change_child_focus( $'.', true );
	if grab_focus_on_start: grab_combo_focus();

func _process( delta ):
	if is_disabled or is_focusing or is_selecting:
		focus_timer += delta;
	elif focus_timer != 0.0:
		focus_timer = 0.0;
	else:
		return;
	if has_node( 'selection_margin/selection' ):
		var node = get_node( 'selection_margin/selection' );
		if node is ColorRect or node is TextureRect:
			set_node_modulate( node, focus_timer, normal_modulate, __cur_color(), __cur_blink(), __cur_change() );

func _input(event):
	if !use_godot_input: return;
	if event is InputEventKey:
		if event.is_action_released('ui_accept'):
			if !is_focusing:		return;
			elif !is_selecting:		is_selecting = true;
		elif event.is_action_released('ui_cancel'):
			if is_selecting:		is_selecting = false;
			elif is_focusing:		is_focusing = false;

func __is_input( event, action_id: String, allow_pressing := false ) -> bool:
	if is_selecting:
		if event is InputEventKey:
			if allow_pressing:
				return event.is_action( action_id, true );
			else:
				return event.is_action_pressed(action_id);
	return false;
