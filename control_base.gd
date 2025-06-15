@tool
extends Control

#
# size mattar
#

var force_changing_minimum_size := false;
func __minimum_size_changed( call_func: Callable ):
	if force_changing_minimum_size: return;
	call_func.call();

func __set_size( auto_update_minimum_size := true ):
	var force_use_custom_minimum_size := false;
	if auto_update_minimum_size:
		var p := get_parent();
		if is_instance_valid(p) and p.is_class( 'BoxContainer' ):
			force_use_custom_minimum_size = true;
	
	if force_use_custom_minimum_size:
		force_changing_minimum_size = true;
		custom_minimum_size = __get_size( $'.', true );
		force_changing_minimum_size = false;
	else:
		set_size( __get_size( $'.', true ) );

func __get_size( node: Control, exclude_self := false ) -> Vector2i:
	var temp_size = Vector2i.ZERO if exclude_self else node.get_combined_minimum_size();
	var counted_offset := Vector2i.ZERO;
	for child_node in node.get_children():
		if !child_node.visible: continue;
		var child_size := __get_size( child_node );
		temp_size.x = max( temp_size.x, counted_offset.x + child_size.x );
		temp_size.y = max( temp_size.y, counted_offset.y + child_size.y );
		if node is HBoxContainer: counted_offset.x += node.get_theme_constant( 'separation' ) + child_size.x;
		if node is VBoxContainer: counted_offset.y += node.get_theme_constant( 'separation' ) + child_size.y;
	return temp_size;

#
# signal connect mattar
#

## the callable_func must return get_instance_id(), or this check fail
func __connect_func_to_signal( signal_to_connect: Signal, callable_func: Callable ) -> bool:
	for connection in signal_to_connect.get_connections():
		if connection.callable == callable_func and connection.callable.call() == get_instance_id():
			return false;
	signal_to_connect.connect( callable_func );
	return true;

func __release_connected_signal( signal_to_release: Signal ) -> bool:
	var any_released := false;
	for connection in signal_to_release.get_connections():
		if connection.callable.call() == get_instance_id():
			signal_to_release.disconnect( connection.callable );
			any_released = true;
	return any_released;
