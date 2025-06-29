@tool
class_name Editor_UiControlsCombo_Basic extends Editor_UiControlsCombo_Base

@export_category('Setting')
@export_group('Config')
## check all child share same parent, with same group_name# prefix.
## e.g. there have three node under same parent:
## [ res#123 ] [ res#456 ] [ res2#789 ]
## only res#123 and res#456 will sync up their size.
## ** P.S. this function will overwrite Label custom_minimum_size **
@export var sync_label_size := false:
	set(new_value):
		sync_label_size = new_value;
		resized_node();
## useful update node size inside box
@export var auto_update_custom_minimum_size := false:
	set(new_value):
		auto_update_custom_minimum_size = new_value;
		resized_node();

var sync_blocker := false;
var sync_size_dict := {};
var saved_root_node: Control;

#
# size control and initialize
#

func check_sync_size():
	if !sync_label_size: return;
	if name.find('#') < 0: return;
	
	var same_group_node := [];
	var max_size_dict := {};
	
	var group_name := name.left( name.find('#') );
	for node in get_parent().get_children():
		if node.name.find('#') < 0: continue;
		if group_name != node.name.left( node.name.find('#') ): continue;
		if node is Editor_UiControlsCombo_Basic:
			
			same_group_node.append( node );
			for id in node.node_dict:
				if node.node_dict[id].has('node') and node.node_dict[id].node is Label:
					if !max_size_dict.has(id): max_size_dict[id] = Vector2.ZERO;
					node.node_dict[id].node.custom_minimum_size = Vector2.ZERO;
					node.node_dict[id].node.reset_size();
					var ms: Vector2 = node.node_dict[id].node.get_combined_minimum_size();
					max_size_dict[id].x = max( max_size_dict[id].x, ms.x );
					max_size_dict[id].y = max( max_size_dict[id].y, ms.y );
	
	same_group_node.append( $'.' );
	for node in same_group_node:
		node.sync_size_dict = max_size_dict;
		node.sync_blocker = true;
		node.update_label();
		node.update_font();
		node.sync_blocker = false;

func resized_node():
	__set_size( auto_update_custom_minimum_size );
	if !sync_blocker: check_sync_size();

func _ready():
	minimum_size_changed.connect( func(): __minimum_size_changed( resized_node ) );
	resized.connect( resized_node );

#
# update ( data from export value )
#

func __in_vertical_box( node ) -> bool:
	return (
		node.get_parent().is_class('VBoxContainer') or (
			!node.get_parent().is_class('HBoxContainer') and
			node.get_parent().is_class('BoxContainer') and
			node.get_parent().vertical
		) 
	);

func __get_and_apply( target_node: Control, data_name: String, property_name: String ):
	var temp_data = get( data_name );
	if typeof( temp_data ) == typeof( target_node[ property_name ] ):
		target_node[ property_name ] = temp_data;

func __get_and_apply_arr( target_node: Control, data_property_arr: Array ):
	for pair in data_property_arr:
		__get_and_apply( target_node, pair[0], pair[1] );

func __set_font_data( node_name: String ):
	if !node_dict[ node_name ].has('node'): return;
	if !node_dict[ node_name ].has('data_name'): return;
	var node = node_dict[ node_name ].node;
	if node is Label:
		var data_group: String = node_dict[ node_name ].data_name.split('_')[0];
		
		var font = get( data_group + '_font' );
		if font is Font:
			if node.get_theme_font('font') != font:
				node.add_theme_font_override( 'font', font );
		else:
			if node.get_theme_font('font') != null:
				node.remove_theme_font_override('font');
		
		var font_color = get( data_group + '_color' );
		if node.get_theme_color( 'font_color' ) != font_color:
			node.add_theme_color_override( 'font_color', font_color );
		
		var font_size = get( data_group + '_size' );
		if node.get_theme_font_size( 'font_size' ) != font_size:
			node.add_theme_font_size_override( 'font_size', font_size );
		
		node.horizontal_alignment = get( data_group + '_halign' );
		node.vertical_alignment = get( data_group + '_valign' );

func update_font():
	for node_name in node_dict:
		if node_dict[ node_name ].node_class != Label: continue;
		__set_font_data( node_name );
	resized_node();

func update_container():
	for node_name in node_dict:
		if (	node_dict[ node_name ].node_class != BoxContainer and
				node_dict[ node_name ].node_class != HBoxContainer and
				node_dict[ node_name ].node_class != VBoxContainer ): continue;
		if !node_dict[ node_name ].has('data_name'): continue;
		
		var node := __check_node_created( node_name );
		if node_dict[ node_name ].node_class == BoxContainer:
			node.vertical = get( node_dict[ node_name ].data_name + '_vertical' ) == true;
		var separation = get( node_dict[ node_name ].data_name + '_separation' );
		if separation != null:
			node.add_theme_constant_override( 'separation', separation );
	resized_node();

func update_texturerect():
	for node_name in node_dict:
		if node_dict[ node_name ].node_class != TextureRect: continue;
		
		var txt_data = get( node_dict[ node_name ].data_name + '_txt' );
		var size_data = get( node_dict[ node_name ].data_name + '_size' );
		if (	txt_data == null or !txt_data.is_class( 'Texture2D' ) or
				( size_data != null and ( size_data.x == 0 or size_data.y == 0 ) ) ):
			__check_node_release( node_name );
			continue;
		
		var node := __check_node_created( node_name );
		if node is TextureRect:
			node.texture = txt_data;
			
			var in_vertical_box := __in_vertical_box( node );
			if size_data is Vector2: node.custom_minimum_size = size_data;
			var modulate_data = get( node_dict[ node_name ].data_name + '_modulate' );
			if modulate_data is Color: node.modulate = modulate_data;
			var align_data = get( node_dict[ node_name ].data_name + '_align' );
			if align_data is SizeFlags:
				if in_vertical_box:	node.size_flags_horizontal = align_data;
				else:				node.size_flags_vertical = align_data;
	resized_node();

func __progressbar_use_texture( node_data_ref: Dictionary ) -> bool:
	var any_txt := false;
	if node_data_ref.has('data_name'):
		var utxt = get( node_data_ref.data_name + '_undertxt' );
		var otxt = get( node_data_ref.data_name + '_overtxt' );
		var ptxt = get( node_data_ref.data_name + '_progresstxt' );
		if utxt is Texture2D:	any_txt = true;
		elif otxt is Texture2D:	any_txt = true;
		elif ptxt is Texture2D:	any_txt = true;
	return any_txt;

func update_progressbar():
	for node_name in node_dict:
		if node_dict[ node_name ].node_class != ProgressBar: continue;
		
		var use_texture := __progressbar_use_texture( node_dict[ node_name ] );
		
		var cur_data = get( node_dict[ node_name ].data_name + '_cur' );
		var max_data = get( node_dict[ node_name ].data_name + '_max' );
		var not_same_class = (
				node_dict[ node_name ].has('node') and
				is_instance_valid(node_dict[ node_name ].node) and
				!node_dict[ node_name ].node.is_class( 'TextureProgressBar' if use_texture else 'ProgressBar' )
				);
		if cur_data == null or max_data == null or not_same_class:
			__check_node_release( node_name );
			if cur_data == null or max_data == null: continue;
		
		var node := __check_node_created( node_name );
		if node is TextureProgressBar:
			node.nine_patch_stretch = get( node_dict[ node_name ].data_name + '_ninepatchstretch' ) == true;
			node.texture_under = get( node_dict[ node_name ].data_name + '_undertxt' );
			node.texture_over = get( node_dict[ node_name ].data_name + '_overtxt' );
			node.texture_progress = get( node_dict[ node_name ].data_name + '_progresstxt' );
			var utint = get( node_dict[ node_name ].data_name + '_undertint' );
			node.tint_under = utint if utint != null else Color.WHITE;
			var otint = get( node_dict[ node_name ].data_name + '_overtint' );
			node.tint_over = otint if otint != null else Color.WHITE;
			var ptint = get( node_dict[ node_name ].data_name + '_progresstint' );
			node.tint_progress = ptint if ptint != null else Color.WHITE;
		if node is ProgressBar:
			node.show_percentage = get( node_dict[ node_name ].data_name + '_showpercentage' ) == true;
			
			var bg_box = get( node_dict[ node_name ].data_name + '_bgbox' );
			if bg_box is StyleBox:		node.add_theme_stylebox_override( 'background', bg_box );
			else:						node.remove_theme_stylebox_override( 'background' );
			var fill_box = get( node_dict[ node_name ].data_name + '_fillbox' );
			if fill_box is StyleBox:	node.add_theme_stylebox_override( 'fill', fill_box );
			else:						node.remove_theme_stylebox_override( 'fill' );
		if node.is_class('ProgressBar') or node.is_class('TextureProgressBar'):
			node.value = cur_data.to_float();
			node.max_value = max_data.to_float();
			
			var in_vertical_box := __in_vertical_box( node );
			var bar_width = get( node_dict[ node_name ].data_name + '_barwidth' );
			var bar_height = get( node_dict[ node_name ].data_name + '_barheight' );
			if bar_width == null: bar_width = 0.0;
			if bar_height == null: bar_height = 0.0;
			if in_vertical_box:	node.custom_minimum_size = Vector2( bar_height, bar_width );
			else:				node.custom_minimum_size = Vector2( bar_width, bar_height );
			
			var align_data = get( node_dict[ node_name ].data_name + '_baralign' );
			if align_data is SizeFlags:
				if in_vertical_box:	node.size_flags_horizontal = align_data;
				else:				node.size_flags_vertical = align_data;
			
			var fill_direct = get( node_dict[ node_name ].data_name + '_filldirect' );
			if fill_direct != null: node.fill_mode = fill_direct;
	resized_node();

func update_label():
	for node_name in node_dict:
		if node_dict[ node_name ].node_class != Label: continue;
		var text_data: String = get( node_dict[ node_name ].data_name );
		if text_data.is_empty() and !sync_size_dict.has( node_name ):
			__check_node_release( node_name );
			continue;
		
		var node := __check_node_created( node_name );
		if node is Label:
			node.text = text_data;
		if sync_size_dict.has( node_name ):
			node.custom_minimum_size = sync_size_dict[ node_name ];
	resized_node();

#
# reorder ( node )
#

func swap_child_align( node_name: String ):
	if !node_dict.has( node_name ): return;
	var node_data: Dictionary = node_dict[ node_name ];
	if !node_data.has('node'): return;
	if !is_instance_valid( node_data.node ): return;
	if !node_data.has('child_idx'): return;
	
	var swap_structure_flag := false;
	var swap_inner_structure_flag := [];
	
	var child_order_structure := [];
	var before_node_class = null;
	var space_flag := false;
	for child_name in node_data.child_idx:
		if !node_dict.has( child_name ): continue;
		var child_data: Dictionary = node_dict[ child_name ];
		if !child_data.has('node'): continue; # skip node not created
		
		if child_order_structure.is_empty() or ( space_flag == ( child_data.node_class != Control ) ):
			child_order_structure.append( [] );
			before_node_class = null;
		space_flag = child_data.node_class == Control;
		
		var inner_structure := child_order_structure.back();
		if inner_structure.is_empty() or before_node_class != child_data.node_class:
			inner_structure.append( [] );
		before_node_class = child_data.node_class;
		inner_structure.back().append( child_data.node );
		
		if !child_data.has('data_name'): continue;
		if get( 'swap_' + child_data.data_name + '_align' ) == true:
			swap_structure_flag = true;
		if get( 'change_' + child_data.data_name + '_align' ) == true:
			var cur_idx := child_order_structure.size() - 1;
			if swap_inner_structure_flag.find( cur_idx ) < 0:
				swap_inner_structure_flag.append( cur_idx );
	
	for idx in swap_inner_structure_flag:
		child_order_structure[ idx ].reverse();
	if swap_structure_flag:
		child_order_structure.reverse();
	
	for inner_structure in child_order_structure:
		for node_arr in inner_structure:
			for child_node in node_arr:
				node_data.node.move_child( child_node, -1 );

func swap_all_align():
	for node_name in node_dict:
		if node_dict[ node_name ].has('child_idx'):
			swap_child_align( node_name );

#
# create ( node )
#

var node_dict := {};
func __create_node( node_data_ref: Dictionary ) -> Control:
	var new_node;
	match node_data_ref.node_class:
		ProgressBar:
			if __progressbar_use_texture( node_data_ref ):
				new_node = TextureProgressBar.new();
			else:
				new_node = ProgressBar.new();
		_:
			new_node = node_data_ref.node_class.new();
	
	if (	new_node.is_class('TextureRect') ):
		new_node.expand_mode = TextureRect.EXPAND_IGNORE_SIZE;
		new_node.stretch_mode = TextureRect.STRETCH_SCALE;
		new_node.size_flags_horizontal = Control.SIZE_SHRINK_CENTER;
		new_node.size_flags_vertical = Control.SIZE_SHRINK_CENTER;
	
	if (	new_node.is_class('MarginContainer') or
			new_node.is_class('Control') or
			new_node.is_class('ProgressBar') or
			new_node.is_class('TextureProgressBar') or
			new_node.is_class('BoxContainer') or
			new_node.is_class('HBoxContainer') or
			new_node.is_class('VBoxContainer') ):
		new_node.set_anchors_and_offsets_preset( Control.PRESET_FULL_RECT );
		new_node.size_flags_horizontal = Control.SIZE_EXPAND_FILL;
		new_node.size_flags_vertical = Control.SIZE_EXPAND_FILL;
	
	node_data_ref.node = new_node;
	return new_node;

func __check_node_created( node_name: String, search_parent := false ) -> Control:
	if !node_dict.has( node_name ):
		if search_parent:	return $'.';
		else:				return;
	var node_data: Dictionary = node_dict[ node_name ];
	if node_data.has('node') and is_instance_valid( node_data.node ):
		return node_data.node;
	
	var new_node = __create_node( node_data );
	new_node.name = '_' + node_name;
	var parent_node = __check_node_created( node_data.parent_name, true );
	parent_node.add_child( new_node );
	swap_child_align( node_data.parent_name );
	return new_node;

func __check_node_release( node_name: String ):
	if !node_dict.has( node_name ): return;
	var node_data: Dictionary = node_dict[ node_name ];
	if !node_data.has('node'): return;
	if is_instance_valid( node_data.node ):
		node_data.node.queue_free();
	node_data.erase('node');

func create_node_index( node_list: Array ):
	var class_include := {};
	
	for idx in range( node_list.size() ):
		var node_name: String = node_list[ idx ][1];
		var parent_node_name: String = node_list[ idx ][2];
		if !node_dict.has( node_name ):
			node_dict[ node_name ] = {};
		node_dict[ node_name ].node_class = node_list[ idx ][3];
		class_include[ node_dict[ node_name ].node_class ] = true;
		node_dict[ node_name ].parent_name = parent_node_name;
		if (	node_dict[ node_name ].node_class == Control or
				node_dict[ node_name ].node_class == MarginContainer or
				node_dict[ node_name ].node_class == BoxContainer or
				node_dict[ node_name ].node_class == HBoxContainer or
				node_dict[ node_name ].node_class == VBoxContainer ):
			__check_node_created( node_name );
		if !node_list[ idx ][0].is_empty():
			node_dict[ node_name ].data_name = node_list[ idx ][0];
		
		if !parent_node_name.is_empty():
			if !node_dict.has( parent_node_name ):
				node_dict[ parent_node_name ] = {};
			if !node_dict[ parent_node_name ].has( 'child_idx' ):
				node_dict[ parent_node_name ].child_idx = [];
			node_dict[ parent_node_name ].child_idx.append( node_name );
	
	if (	class_include.has( BoxContainer ) or
			class_include.has( HBoxContainer ) or
			class_include.has( VBoxContainer ) ): update_container();
	if class_include.has( Label ):
		update_label();
		update_font();
	if class_include.has( TextureRect ): update_texturerect();
	if class_include.has( ProgressBar ): update_progressbar();
	swap_all_align();
