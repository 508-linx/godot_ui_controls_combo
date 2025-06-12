@tool
extends Node

func __get_size( node: Control, exclude_self := false ) -> Vector2i:
	var temp_size = Vector2i.ZERO if exclude_self else node.get_combined_minimum_size();
	var counted_offset := Vector2i.ZERO;
	for child_node in node.get_children():
		var child_size := __get_size( child_node );
		temp_size.x = max( temp_size.x, counted_offset.x + child_size.x );
		temp_size.y = max( temp_size.y, counted_offset.y + child_size.y );
		if node is HBoxContainer: counted_offset.x += node.get_theme_constant( 'separation' ) + child_size.x;
		if node is VBoxContainer: counted_offset.y += node.get_theme_constant( 'separation' ) + child_size.y;
	return temp_size;

func resized( parent_node: Control ):
	parent_node.get_node( 'root' ).set_anchors_and_offsets_preset( Control.PRESET_FULL_RECT );
	if parent_node.get_parent() is BoxContainer: return;
	if parent_node.get_parent() is HBoxContainer: return;
	if parent_node.get_parent() is VBoxContainer: return;
	parent_node.set_size( __get_size( parent_node, true ) );

func create_hboxaligned_node( parent_node: Control, node_list: Array ):
	var root_node := HBoxContainer.new();
	root_node.name = 'root';
	root_node.set_anchors_and_offsets_preset( Control.PRESET_FULL_RECT );
	parent_node.add_child( root_node );
	
	for item in node_list:
		var data_name: String = item[0];
		var node_class = item[1];
		
		var new_node = node_class.new();
		if data_name.is_empty():
			new_node.name = 'space_0';
			new_node.size_flags_horizontal = Control.SIZE_EXPAND_FILL;
		else:
			new_node.name = 'node_' + data_name;
			new_node.size_flags_vertical = Control.SIZE_EXPAND_FILL;
		root_node.add_child( new_node );

func assign_font( node: Label, font ):
	if font is Font:
		if node.get_theme_font('font') != font:
			node.add_theme_font_override( 'font', font );
	else:
		if node.get_theme_font('font') != null:
			node.remove_theme_font_override('font');

func assign_font_color( node: Label, font_color: Color ):
	var cur_value := node.get_theme_color( 'font_color' );
	if cur_value == font_color: return;
	node.add_theme_color_override( 'font_color', font_color );

func assign_font_size( node: Label, font_size: int ):
	var cur_value := node.get_theme_font_size( 'font_size' );
	if cur_value == font_size: return;
	node.add_theme_font_size_override( 'font_size', font_size );
