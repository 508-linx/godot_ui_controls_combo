@tool
class_name Editor_UiControlsCombo_Basic_ResourceTypeA extends Editor_UiControlsCombo_Basic

@export_category('Setting')
@export var swap_info_align := false:
	set(new_value):
		swap_info_align = new_value;
		swap_all_align();
@export var change_icon_align := false:
	set(new_value):
		change_icon_align = new_value;
		swap_all_align();
@export var swap_bar_align := false:
	set(new_value):
		swap_bar_align = new_value;
		swap_all_align();

@export_group('Container')
@export var bar_container_vertical := true:
	set(new_value):
		bar_container_vertical = new_value;
		update_container();
		update_progressbar();
@export var bar_container_separation := 4.0:
	set(new_value):
		bar_container_separation = new_value;
		update_container();
@export var info_container_separation := 4.0:
	set(new_value):
		info_container_separation = new_value;
		update_container();

@export_group('Icon')
@export var icon_txt: Texture2D:
	set(new_value):
		icon_txt = new_value;
		update_texturerect();
@export var icon_size := Vector2( 16, 16 ):
	set(new_value):
		icon_size = new_value;
		update_texturerect();
@export var icon_align := Control.SIZE_SHRINK_CENTER:
	set(new_value):
		icon_align = new_value;
		update_texturerect();
@export var icon_modulate := Color.WHITE:
	set(new_value):
		icon_modulate = new_value;
		update_texturerect();

@export_group('Label')
@export_subgroup('Text')
@export var title_prefix := '':
	set(new_value):
		title_prefix = new_value;
		update_label();
@export var title := 'Resource Name':
	set(new_value):
		title = new_value;
		update_label();
@export var title_surfix := '':
	set(new_value):
		title_surfix = new_value;
		update_label();
@export var value_prefix := '[':
	set(new_value):
		value_prefix = new_value;
		update_label();
@export var value_cur := '0':
	set(new_value):
		value_cur = new_value;
		update_label();
		update_progressbar();
@export var value_sep := '/':
	set(new_value):
		value_sep = new_value;
		update_label();
@export var value_max := '0':
	set(new_value):
		value_max = new_value;
		update_label();
		update_progressbar();
@export var value_surfix := ']':
	set(new_value):
		value_surfix = new_value;
		update_label();

@export_subgroup('Font')
## set this value assign to all font
@export var font: Font:
	set(new_value):
		font = new_value;
		if !stop_sync_font:
			stop_sync_font = true;
			title_font = new_value;
			value_font = new_value;
			stop_sync_font = false;
			update_font();
@export var title_font: Font:
	set(new_value):
		title_font = new_value;
		if !stop_sync_font:
			stop_sync_font = true;
			font = null;
			stop_sync_font = false;
			update_font();
@export var value_font: Font:
	set(new_value):
		value_font = new_value;
		if !stop_sync_font:
			stop_sync_font = true;
			font = null;
			stop_sync_font = false;
			update_font();

var stop_sync_font := false;

@export var title_color := Color.LIGHT_GRAY:
	set(new_value):
		title_color = new_value;
		update_font();
@export var title_size := 16:
	set(new_value):
		title_size = new_value;
		update_font();
@export var title_halign := HORIZONTAL_ALIGNMENT_LEFT:
	set(new_value):
		title_halign = new_value;
		update_font();
@export var title_valign := VERTICAL_ALIGNMENT_TOP:
	set(new_value):
		title_valign = new_value;
		update_font();

@export var value_color := Color.LIGHT_GRAY:
	set(new_value):
		value_color = new_value;
		update_font();
@export var value_size := 16:
	set(new_value):
		value_size = new_value;
		update_font();
@export var value_halign := HORIZONTAL_ALIGNMENT_LEFT:
	set(new_value):
		value_halign = new_value;
		update_font();
@export var value_valign := VERTICAL_ALIGNMENT_TOP:
	set(new_value):
		value_valign = new_value;
		update_font();

@export_group('Bar')
@export var value_filldirect := ProgressBar.FillMode.FILL_BEGIN_TO_END:
	set(new_value):
		value_filldirect = new_value;
		update_progressbar();
## x size while inside hbox, y size while inside vbox
@export var value_barwidth := 8.0:
	set(new_value):
		value_barwidth = new_value;
		update_progressbar();
## y size while inside hbox, x size while inside vbox
@export var value_barheight := 0.0:
	set(new_value):
		value_barheight = new_value;
		update_progressbar();
@export var value_baralign := Control.SIZE_FILL:
	set(new_value):
		value_baralign = new_value;
		update_progressbar();

@export_subgroup('StyleBox')
@export var value_showpercentage := false:
	set(new_value):
		value_showpercentage = new_value;
		update_progressbar();
@export var value_bgbox: StyleBox:
	set(new_value):
		value_bgbox = new_value;
		update_progressbar();
@export var value_fillbox: StyleBox:
	set(new_value):
		value_fillbox = new_value;
		update_progressbar();

@export_subgroup('Texture')
@export var value_ninepatchstretch := true:
	set(new_value):
		value_ninepatchstretch = new_value;
		update_progressbar();
@export var value_undertxt: Texture2D:
	set(new_value):
		value_undertxt = new_value;
		update_progressbar();
@export var value_overtxt: Texture2D:
	set(new_value):
		value_overtxt = new_value;
		update_progressbar();
@export var value_progresstxt: Texture2D:
	set(new_value):
		value_progresstxt = new_value;
		update_progressbar();
@export var value_undertint := Color.WHITE:
	set(new_value):
		value_undertint = new_value;
		update_progressbar();
@export var value_overtint := Color.WHITE:
	set(new_value):
		value_overtint = new_value;
		update_progressbar();
@export var value_progresstint := Color.WHITE:
	set(new_value):
		value_progresstint = new_value;
		update_progressbar();

var node_list := [
	[ 'bar_container',	'align_bar',			'',				BoxContainer ],
	[ 'info_container',	'align_info',			'align_bar',	HBoxContainer ],
	[ 'icon',			'texture_icon',			'align_info',	TextureRect ],
	[ 'title_prefix',	'label_title_prefix',	'align_info',	Label ],
	[ 'title',			'label_title',			'align_info',	Label ],
	[ 'title_surfix',	'label_title_surfix',	'align_info',	Label ],
	[ 'info',			'space_info',			'align_info',	Control ],
	[ 'value_prefix',	'label_value_prefix',	'align_info',	Label ],
	[ 'value_cur',		'label_value_cur',		'align_info',	Label ],
	[ 'value_sep',		'label_value_sep',		'align_info',	Label ],
	[ 'value_max',		'label_value_max',		'align_info',	Label ],
	[ 'value_surfix',	'label_value_surfix',	'align_info',	Label ],
	[ 'bar',			'space_bar',			'align_bar',	Control ],
	[ 'value',			'progressbar_value',	'align_bar',	ProgressBar ],
];



func _ready():
	create_node_index( node_list );
	super._ready();
