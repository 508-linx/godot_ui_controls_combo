## Menu Combo Base Class

### Class

- Control < Editor_UiControlsCombo_Menu

### Method

- **void** set_node_modulate( node: **Control**, timer: **float** = null, normal_color: **Color** = null, target_color: **Color** = null, blinking: **bool** = null, change_time: **float** = null )

> apply combo modulate setting to target node  
> also can apply calculated modulate by input setting

- **void** focus_back_node()

> change focus to before Editor_UiControlsCombo_Menu under same parent, loop inside parent Node
> NOTE/TODO: will add option to change focus to other parent

- **void** focus_next_node()

> change focus to next Editor_UiControlsCombo_Menu under same parent, loop inside parent Node
> NOTE/TODO: will add option to change focus to other parent

- **void** grab_combo_focus( add_selection: **Bool** = *false* )

> change is_focusing to true while NOT disabled  
> while add_selection is true + is_selecting is false,  
> check any neighbor is_selecting equal true than change is_selecting to true  
> skip this check while sync_focusing is true, because is_selecting already sync with is_focusing while this property is true

- **void** release_combo_focus( add_selection: **Bool** = *false* )

> change is_focusing to false while NOT disabled  
> while add_selection is false + is_selecting is true,  
> change is_selecting to false and release all neighbor is_selecting  

- **void** change_focus( target_node: **Editor_UiControlsCombo_Menu**, add_selection: **Bool** = *false* )

> change focus to target node, only work while is_focusing equal true

---

## Button

### Class

- Control < Editor_UiControlsCombo_Menu < Editor_UiControlsCombo_Menu_Button

### Method

- **void** click_button()

> set combo_button_pressed to invert assigned node_button property button_pressed, than update combo  
> nothing occur while haven't Node assigned

- **void** press_button()

> change combo_button_pressed to true than update combo

- **void** release_button()

> change combo_button_pressed to false than update combo

---

## Node Hider

### Class

- Control < Editor_UiControlsCombo_Menu < Editor_UiControlsCombo_Menu_NodeHider

### Method

- **void** click_button()

> set combo_button_pressed to invert assigned node_button property button_pressed, than update combo  
> nothing occur while haven't Node assigned

- **void** press_button()

> change combo_button_pressed to true than update combo

- **void** release_button()

> change combo_button_pressed to false than update combo

---

