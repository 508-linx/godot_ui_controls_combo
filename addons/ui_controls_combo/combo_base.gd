@tool
extends 'res://addons/ui_controls_combo/control_base.gd'

@export_category('Setting')
@export_group('Config')
@export var auto_update_custom_minimum_size := false;

#
# size control and initialize
#

# get real content root node exclude align node
func __get_root_node() -> Control:
	if !has_node( 'root' ): return;
	return get_node( 'root' );

func resized_node():
	var root_node := __get_root_node();
	if root_node == null: return;
	
	root_node.set_anchors_and_offsets_preset( Control.PRESET_FULL_RECT );
	__set_size( auto_update_custom_minimum_size );

func _ready():
	minimum_size_changed.connect( func(): __minimum_size_changed( resized_node ) );
	resized.connect( resized_node );

#
# update ( data from export value )
#

func __get_and_apply( target_node: Control, data_name: String, property_name: String ):
	var temp_data = get( data_name );
	if typeof( temp_data ) == typeof( target_node[ property_name ] ):
		target_node[ property_name ] = temp_data;

func __get_and_apply_arr( target_node: Control, data_property_arr: Array ):
	for pair in data_property_arr:
		__get_and_apply( target_node, pair[0], pair[1] );

func update_font( node_list: Array ):
	var root_node := __get_root_node();
	if root_node == null: return;
	
	for item in node_list:
		if item[2] != Label: continue;
		var data_name: String = item[0];
		var node: Label = root_node.get_node( item[1] );
		assign_font( node, get( 'font' ) );
		var data_group: String = data_name.split('_')[0];
		assign_font_color( node, get( data_group + '_color' ) );
		assign_font_size( node, get( data_group + '_size' ) );
		
		__get_and_apply_arr( node, [
			[ data_group + '_halign', 'horizontal_alignment' ],
			[ data_group + '_valign', 'vertical_alignment' ],
		] );
	resized_node();

func update_text( node_list: Array ):
	var root_node := __get_root_node();
	if root_node == null: return;
	
	for item in node_list:
		if item[2] != Label: continue;
		var node: Label = root_node.get_node( item[1] );
		
		__get_and_apply( node, item[0], 'text' );
		
		node.visible = !node.text.is_empty();
	resized_node();

func update_icon( node_list: Array ):
	var root_node := __get_root_node();
	if root_node == null: return;
	
	for item in node_list:
		if item[2] != TextureRect: continue;
		var data_name: String = item[0];
		var node: TextureRect = root_node.get_node( item[1] );
		node.expand_mode = TextureRect.EXPAND_IGNORE_SIZE;
		node.stretch_mode = TextureRect.STRETCH_SCALE;
		
		__get_and_apply_arr( node, [
			[ data_name + '_valign', 'size_flags_vertical' ],
			[ data_name + '_size', 'custom_minimum_size' ],
			[ data_name + '_modulate', 'modulate' ],
			[ data_name + '_txt', 'texture' ],
		] );
		
		node.visible = true;
		var icon_size = get( data_name + '_size' );
		if icon_size != null and ( icon_size.x == 0 or icon_size.y == 0 ):
			node.visible = false;
		var icon_txt = get( data_name + '_txt' );
		if icon_txt == null:
			node.visible = false;
	resized_node();

#
# reorder ( node )
#

func swap_align( node_list: Array, invert_align := false, invert_first_align := false ):
	var root_node := __get_root_node();
	if root_node == null: return;
	
	var is_space := false;
	var align_list := [];
	for item in node_list:
		var data_name: String = item[0];
		var node_name: String = item[1];
		
		if (	align_list.is_empty() or
				( data_name.is_empty() and !is_space ) or
				( !data_name.is_empty() and is_space ) ):
			align_list.append( [] );
		is_space = data_name.is_empty();
		if invert_align:
			align_list.back().insert( 0, node_name );
		else:
			align_list.back().append( node_name );
	if invert_first_align and !align_list.is_empty() and !align_list[0].is_empty():
		if invert_align:
			align_list[0].insert( 0, align_list[0].back() );
			align_list[0].pop_back();
		else:
			align_list[0].append( align_list[0].front() );
			align_list[0].pop_front();
	
	var to_pos := 0 if invert_align else ( node_list.size()-1 );
	for align_node_list in align_list:
		for node_name in align_node_list:
			var node = root_node.get_node( node_name );
			root_node.move_child( node, to_pos );

#
# create ( node )
#

func create_hboxaligned_node( node_list: Array ):
	var created_flag := {};
	
	var root_node := HBoxContainer.new();
	root_node.name = 'root';
	root_node.set_anchors_and_offsets_preset( Control.PRESET_FULL_RECT );
	add_child( root_node );
	
	for item in node_list:
		var data_name: String = item[0];
		var node_name: String = item[1];
		var node_class = item[2];
		
		created_flag[ node_class ] = true;
		
		var new_node = node_class.new();
		new_node.name = node_name;
		if data_name.is_empty():
			new_node.size_flags_horizontal = Control.SIZE_EXPAND_FILL;
		else:
			new_node.size_flags_vertical = Control.SIZE_EXPAND_FILL;
		match node_class:
			TextureRect:
				new_node.expand_mode = TextureRect.EXPAND_IGNORE_SIZE;
				new_node.stretch_mode = TextureRect.STRETCH_SCALE;
		root_node.add_child( new_node );
	
	if created_flag.has( Label ) and created_flag[ Label ]:
		update_font( node_list );
		update_text( node_list );
	if created_flag.has( TextureRect ) and created_flag[ TextureRect ]:
		update_icon( node_list );

#
# assign ( data to property )
#

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
