#!/bin/sh
# Default acpi script that takes an entry for all actions

# NOTE: This is a 2.6-centric script.  If you use 2.4.x, you'll have to
#       modify it to not use /sys

minspeed=`cat /sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_min_freq`
maxspeed=`cat /sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_max_freq`
setspeed="/sys/devices/system/cpu/cpu0/cpufreq/scaling_setspeed"

set $*

PID=$(pgrep dbus-launch)
export USER=$(ps -o user --no-headers $PID)
USERHOME=$(getent passwd $USER | cut -d: -f6)
export XAUTHORITY="$USERHOME/.Xauthority"
for x in /tmp/.X11-unix/*; do
    displaynum=`echo $x | sed s#/tmp/.X11-unix/X##`
    if [ x"$XAUTHORITY" != x"" ]; then
        export DISPLAY=":$displaynum"
    fi
done

case "$1" in
    button/power)
        #echo "PowerButton pressed!">/dev/tty5
        case "$2" in
            PBTN|PWRF)
		    logger "PowerButton pressed: $2, shutting down..."
		    shutdown -P now
		    ;;
            *)      logger "ACPI action undefined: $2" ;;
        esac
        ;;
    button/sleep)
        case "$2" in
            SBTN|SLPB)
		    # suspend-to-ram
		    logger "Sleep Button pressed: $2, suspending..."
		    zzz
		    ;;
            *)      logger "ACPI action undefined: $2" ;;
        esac
        ;;
    ac_adapter)
        case "$2" in
            AC|ACAD|ADP0|ACPI0003:00)
                case "$4" in
                    00000000)
                        echo -n $minspeed >$setspeed
						logger "Unplugged from AC power"
						#if you're caffeinated, forget that cause no AC power and goto sleep
						if [ -f /tmp/caffeinated ]; then
							zzz
						fi
                        #/etc/laptop-mode/laptop-mode start
                    ;;
                    00000001)
                        echo -n $maxspeed >$setspeed
						logger "Plugged into AC power"
                        #/etc/laptop-mode/laptop-mode stop
                    ;;
                esac
                ;;
            *)  logger "ACPI action undefined: $2" ;;
        esac
        ;;
    battery)
        case "$2" in
            BAT0)
                case "$4" in
                    00000000)   #echo "offline" >/dev/tty5
                    ;;
                    00000001)   #echo "online"  >/dev/tty5
                    ;;
                esac
                ;;
            CPU0)
                ;;
            *)  logger "ACPI action undefined: $2" ;;
        esac
        ;;
    button/lid)
	case "$3" in
		close)
			if [ -f /tmp/cafe ]; then
				logger "LID closed while caffeinated, locking screen and un-caffeinating"
				rm /tmp/cafe
				touch /tmp/caffeinated
                xautolock -locknow
			else
				logger "LID closed, suspending..."
                xautolock -locknow
                sleep 5
				zzz
			fi
			;;
		open)	
			logger "LID opened"
			test -f /tmp/caffeinated && rm /tmp/caffeinated
			;;
		*) logger "ACPI action undefined (LID): $2";;
	esac
	;;
    ibm/hotkey|thermal_zone) ;; #ignore
    *)
        logger "ACPI group/action undefined: $1 / $2"
        ;;
esac
