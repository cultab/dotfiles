# NEW

1. install fprintd

2. create udev rule for device with ID from lsusb:
in file {number}-fprintd-{whatever}.rules
eg: 59-fprintd-plugdev.rules

ATTRS{idVendor}=="147e", ATTRS{idProduct}=="2020",  MODE="0664", GROUP="plugdev"

3. add polkit rule to allow plugdev members to list fingers (rule is ./50-fprintd.rules)

4. add yourself to plugdev group

5. ??? ( restart )

6. profit

# OLD

depends: udev, polkit, elogind.. yes :\
install fingerprint-gui

create udev rule for device with ID from lsusb:

in file {number}-fingerprint-gui-{whatever}.rules
ATTRS{idVendor}=="147e", ATTRS{idProduct}=="2020",  MODE="0664", GROUP="plugdev"

or if the above does not work
KERNEL=="uinput", MODE="0664", GROUP="plugdev"

usermod -a -G plugdev $USER

place in /etc/pam.d/{su,sudo,xyz}
take care of the order e.g.
auth sufficient pam_fingerprint-gui.so

