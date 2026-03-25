# Custom QML Widget

## Injecting into a layer attribute

The following line specifies which attribute the final value will be injected into:

https://github.com/opengisch/mapa_das_periferias/blob/871f2eea43e577fd1297128495fe4e285bcc334e/custom_qml_widget/widget_code.qml#L14

## Modifying the widget elements

The listModel here is used to define:
1. The svg icon to render (for the user to click).
2. The colour to use for the stroke / fill of the button:
  a. By default all buttons have a stroke / border based on this colour.
  b. When the user clicks on a button, the stroke is removed and the fill is added of the same colour (to indicate it's selected).
3. The value to place in the linked field above.

https://github.com/opengisch/mapa_das_periferias/blob/871f2eea43e577fd1297128495fe4e285bcc334e/custom_qml_widget/widget_code.qml#L23-L49
