depends: udev, polkit, elogind.. yes :\
install fingerprint-gui

create udev rule for device with ID from lsusb:

in file {number}-fingerprint-gui-{whatever}.rules
ATTRS{idVendor}=="147e", ATTRS{idProduct}=="2020",  MODE="0664", GROUP="plugdev"

or if the above does not work
KERNEL=="uinput", MODE="0664", GROUP="plugdev"

usermod -a -G plugdev $USER

# place in /etc/pam.d/{su,sudo,xyz}
# take care of the order e.g.
auth sufficient pam_fingerprint-gui.so

