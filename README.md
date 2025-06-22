# Godot Ui Controls Combo Addons

### What's this addons done?

> Add some preset controls combo for UI

### Available Controls Combo

1. Baisc UI Combo

*SIMPLE LIFE HACKS COMBO*  
*just some combo to automation create multi node by simple input*

> ## ![Status Label](addons/ui_controls_combo/icon/status_label.png) Status Label
>
> ![Status Label Preview](addons/ui_controls_combo/preview/status_label.png)
> 
> - Structure:
> - - **[ HBoxContainer ]** *:* **[ Icon ]**, **[ Name ]**, *[ Space ]*, **[ Value ]**
> - Can swap Left-Right position with one-click *(controled by bool value)*
> - Can swap Icon-Name position with one-click *(controled by bool value)*

> ## ![Resource Label](addons/ui_controls_combo/icon/resource_label.png) Resource Label
>
> ![Resource Label Preview](addons/ui_controls_combo/preview/resource_label.png)
> 
> - Structure:
> - - **[ VBoxContainer ]** *:*
> - - - **[ HBoxContainer ]** *:* **[ Icon ]**, **[ Name ]**, *[ Space ]*, **[ Current Value ]**, **[ Max Value ]**
> - - - **[ ProgressBar ]**
> - Can swap Up-Down position with one-click *(controled by bool value)*
> - Can swap Left-Right position with one-click *(controled by bool value)*
> - Can swap Icon-Name position with one-click *(controled by bool value)*

2. Menu Combo

*HIGH CUSTOMIZABLE FUNCTIONAL COMBO*  
*need to ASSIGN NODE to activate*

> ## ![Button](addons/ui_controls_combo/icon/button.png) Button
>
> ![Button Preview](addons/ui_controls_combo/preview/button.png)
> 
> - Structure:
> - - **[ Any BaseButton ]**
> - Need to PLACE any BaseButton NODE as CHILD, and ASSIGN them to activate
> - Can use Godot build-in focus system or disable and control by calling func

> ## ![Option Button](addons/ui_controls_combo/icon/option_button.png) Option Button
>
> ![Option Button Preview](addons/ui_controls_combo/preview/option_button.png)
> 
> - Structure:
> - - **[ OptionButton ]**
> - Need to PLACE any OptionButton NODE as CHILD, and ASSIGN them to activate
> - Can use Godot build-in focus system or disable and control by calling func

> ## ![Switch](addons/ui_controls_combo/icon/switch.png) Switch
>
> ![Switch Preview](addons/ui_controls_combo/preview/switch.png)
> 
> - Structure:
> - - **[ Any BaseButton ] x 2**
> - - **[ CheckButton ]**
> - Need to PLACE *"any two BaseButton"* or *"CheckButton"* or *both* NODE as CHILD, and ASSIGN them to activate
> - Can use Godot build-in focus system or disable and control by calling func

> ## ![Radio Button](addons/ui_controls_combo/icon/radio_button.png) Radio Button
>
> ![Radio Button Preview](addons/ui_controls_combo/preview/radio_button.png)
> 
> - Structure:
> - - **[ Any BaseButton ] x n**
> - Need to PLACE one or more BaseButton NODE as CHILD, and ASSIGN them to activate
> - Can use Godot build-in focus system or disable and control by calling func

> ## ![Slider](addons/ui_controls_combo/icon/slider.png) Slider
>
> ![Slider Preview](addons/ui_controls_combo/preview/slider.png)
> 
> - Structure:
> - - **[ Any Slider ]**
> - - **[ Label (Optional, for value display) ]**
> - - **[ Any BaseButton (Optional, for mouse click value step) ] x 2**
> - Need to PLACE any Slider NODE as CHILD, and ASSIGN them to activate
> - Can use Godot build-in focus system or disable and control by calling func

> ## ![Node Hider](addons/ui_controls_combo/icon/node_hider.png) Node Hider
>
> ![Node Hider Preview](addons/ui_controls_combo/preview/node_hider.png)
> 
> - Structure:
> - - **[ Any Node (Optional, visible while button pressed) ] x n**
> - - **[ Any Node (Optional, visible while button released) ] x n**
> - Need to ASSIGN NODE to activate
> - AUTO CREATE a invisible toggle button and switch assigned node visible by button state
> - Can use Godot build-in focus system or disable and control by calling func

3. NON Controls Combo UI Node (Extra Content, maybe SHOULD NOT be here)

*ANOTHER SIMPLE LIFE HACKS NODE*  
*auto draw content by simple value input*
*well... maybe they are not a controls combo...*

> ## ![Resource Indicator](addons/ui_controls_combo/icon/resource_indicator.png) Resource Indicator
>
> ![Resource Indicator Preview](addons/ui_controls_combo/preview/resource_indicator.png)
> 
> - Use Draw func to simple draw out **Multi Line** like ProgressBar inside BoxContainer to display input value
> - Can active value draw out with format setting
> - Can switch to Verticle Version
> - NOT set position itself, attach to target Node and set position offset manually


