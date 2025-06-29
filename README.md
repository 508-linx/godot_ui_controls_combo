# Godot Ui Controls Combo Addons

### What dose this addons done?

- Add some preset UI controls combo

### Any Document for Detail?

- for property and signal -> see description inside editor
- for method -> [here](DOCUMENT.md) **WIP**

## Available Controls Combo

### 1. Baisc UI Combo

###### *SIMPLE LIFE HACKS COMBO*

- *create multi node combo by simple input automatically*

> ## ![Status Label](addons/ui_controls_combo/icon/status_label.png) Status Label
>
> ![Status Label Preview](addons/ui_controls_combo/preview/status_label.png)
> 
> - Structure:
>   - **[ HBoxContainer ]** *:* **[ Icon ]**, **[ Name ]**, *[ Space ]*, **[ Value ]**
> - Feature:
>   - Can swap Left-Right position with one-click *(controled by bool value)*
>   - Can swap Icon-Name position with one-click *(controled by bool value)*

> ## ![Resource Label TypeA](addons/ui_controls_combo/icon/resource_label.png) Resource Label TypeA
>
> ![Resource Label TypeA Preview](addons/ui_controls_combo/preview/resource_label.png)
> 
> - Structure:
>   - **[ BoxContainer ]** *:*
>     - **[ HBoxContainer ]** *:* **[ Icon ]**, **[ Name ]**, *[ Space ]*, **[ Current Value ]**, **[ Max Value ]**
>     - *[ Space ]*
>     - **[ ProgressBar ]**
> - Feature:
>   - Can swap Left-Right position with one-click *(controled by bool value)*
>   - Can swap Icon-Name position with one-click *(controled by bool value)*
>   - Can swap Labels-ProgressBar position with one-click *(controled by bool value)*
>   - Can change ProgressBar position to left/right with one-click *(controled by bool value, set BoxContainer vertical)*

> ## ![Resource Label TypeB](addons/ui_controls_combo/icon/resource_label.png) Resource Label TypeB
>
> ![Resource Label TypeB Preview](addons/ui_controls_combo/preview/resource_label_b.png)
> 
> - Structure:
>   - **[ BoxContainer ]** *:* **[ Icon ]**, **[ Name ]**, *[ Space ]*, **[ ProgressBar ]**, **[ Current Value ]**, **[ Max Value ]**
> - Feature:
>   - Can swap Left-Right position with one-click *(controled by bool value)*
>   - Can swap Icon-Name position with one-click *(controled by bool value)*
>   - Can swap ProgressBar-Value position with one-click *(controled by bool value)*
>   - Can change whole Node to vertical

### 2. Menu Combo

###### *HIGH CUSTOMIZABLE FUNCTIONAL COMBO*

- *MUST ASSIGN NODE to activate*
- *Can use Godot build-in focus system or disable than control by calling func instead*

> ## ![Button](addons/ui_controls_combo/icon/button.png) Button
>
> ![Button Preview](addons/ui_controls_combo/preview/button.png)
> 
> - Structure:
>   - **[ Any BaseButton ]**
> - Need to PLACE any BaseButton NODE as CHILD, and ASSIGN them to activate

> ## ![Option Button](addons/ui_controls_combo/icon/option_button.png) Option Button
>
> ![Option Button Preview](addons/ui_controls_combo/preview/option_button.png)
> 
> - Structure:
>   - **[ OptionButton ]**
> - Need to PLACE any OptionButton NODE as CHILD, and ASSIGN them to activate

> ## ![Switch](addons/ui_controls_combo/icon/switch.png) Switch
>
> ![Switch Preview](addons/ui_controls_combo/preview/switch.png)
> 
> - Structure:
>   - **[ Any BaseButton ] x 2**
>   - **[ CheckButton ]**
> - Need to PLACE *"any two BaseButton"* or *"CheckButton"* or *both* NODE as CHILD, and ASSIGN them to activate

> ## ![Radio Button](addons/ui_controls_combo/icon/radio_button.png) Radio Button
>
> ![Radio Button Preview](addons/ui_controls_combo/preview/radio_button.png)
> 
> - Structure:
>   - **[ Any BaseButton ] x n**
> - Need to PLACE one or more BaseButton NODE as CHILD, and ASSIGN them to activate

> ## ![Slider](addons/ui_controls_combo/icon/slider.png) Slider
>
> ![Slider Preview](addons/ui_controls_combo/preview/slider.png)
> 
> - Structure:
>   - **[ Any Slider ]**
>   - **[ Label (Optional, for value display) ]**
>   - **[ Any BaseButton (Optional, for mouse click value step) ] x 2**
> - Need to PLACE any Slider NODE as CHILD, and ASSIGN them to activate

> ## ![Node Hider](addons/ui_controls_combo/icon/node_hider.png) Node Hider
>
> ![Node Hider Preview](addons/ui_controls_combo/preview/node_hider.png)
> 
> - Structure:
>   - **[ Any Node (Optional, visible while button pressed) ] x n**
>   - **[ Any Node (Optional, visible while button released) ] x n**
> - AUTO CREATE a invisible toggle button and switch assigned node visible by button state

### 3. NON Controls Combo UI Node (maybe SHOULD NOT be here)

###### *ANOTHER SIMPLE LIFE HACKS NODE*

- *auto draw content by simple value input*
- *well... maybe they not count as controls combo...*

> ## ![Resource Indicator](addons/ui_controls_combo/icon/resource_indicator.png) Resource Indicator
>
> ![Resource Indicator Preview](addons/ui_controls_combo/preview/resource_indicator.png)
> 
> - Use Draw func to simple draw out **Multi Line** like ProgressBar inside BoxContainer to display input value
> - Feature:
>   - Can draw value with format setting
>   - Can set line size, sperate size and draw offset
>   - Can adjust color
>   - Can switch to Verticle



