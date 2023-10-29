Copy /lib/udev/hwdb.d/60-keyboard.hwdb to /etc/udev/hwdb.d/

```
683:# KEYBOARD_KEY_07=zoom                                   # Fn+F8 screen expand
689:# KEYBOARD_KEY_13=zoom                                   # Fn+Space
703:# KEYBOARD_KEY_900f8=zoom
731:# KEYBOARD_KEY_13=zoom
749:# KEYBOARD_KEY_09001d=zoom                               # Fn+Space
1456:# KEYBOARD_KEY_0e=zoom                                   # Fn+F10
```

After that :

```
udevadm hwdb --update
udevadm control --reload-rules
udevadm trigger
```
