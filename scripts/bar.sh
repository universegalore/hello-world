#!/usr/bin/env bash

# source the colors from colors.sh
source "/usr/scripts/colors.sh"

# vars
p="  "

desktops() {
	cur=`xprop -root _NET_CURRENT_DESKTOP | awk '{print $3}'`
	tot=`xprop -root _NET_NUMBER_OF_DESKTOPS | awk '{print $3}'`

	for w in `seq 0 $((cur - 1))`; do line="${line}◽ "; done
	line="${line}◾"
	for w in `seq $((cur + 2)) $tot`; do line="${line} ◽"; done
	echo $line
}

workspace() {
	cur=$(xdotool "get_desktop")

	if [ "$cur" == "0" ] ; then
		printf "1"
	elif [ "$cur" == "1" ] ; then
		printf "2"
	elif [ "$cur" == "2" ] ; then
		printf "3"
	elif [ "$cur" == "3" ] ; then
		printf "4"
	elif [ "$cur" == "4" ] ; then
		printf "5"
	else
		printf "???"
	fi
}

window() {
	cwindow=$(xdotool "getwindowfocus" "getwindowname" | head -c50)

	if [ "$cwindow" == "Openbox" ] ; then
		echo ""
	else
		echo "  $cwindow  "
	fi
}

song() {
	csong=$(mpc -p 6600 current | head -c50)
	playing=$(mpc -p 6600 status| grep -o 'playing' )

	if [ "$playing" == "playing" ]; then
		echo "   $csong  "
	else [ "$playing" == "" ];
		echo ""
	fi
}

clock() {
	datetime=$(date "+%A %I:%M%P")
	echo $datetime
}

weather() {
	cat "/tmp/weather"
}

network() {
	cnetwork=$(iwgetid -r)

	if [ "$cnetwork" == "" ]; then
		echo $wrn$txt offline
	else
		echo  $cnetwork
	fi
}

sound() {
	level=$(amixer get Master 2>&1 | awk '/Front Left:/{gsub(/[\[\]]/, "", $5); print $5}')
	if [ "$level" == "0%" ]; then
		echo $wrn$txt
	else
		echo  $level
	fi
}

battery() {
    percent=$(cat /sys/class/power_supply/BAT0/capacity)
    power=$(cat /sys/class/power_supply/BAT0/status)
	
	if [[ $power == "Charging" || $power == "Unknown" ]]; then
		echo -n " $percent%"
	else
		if [ $percent -eq 100 ]; then
			echo -n " $percent%"
		elif [ $percent -gt 80 ] ; then
			echo -n " $percent%"
		elif [ $percent -gt 30 ]; then
			echo -n " $percent%"
		else 
			echo -n " $percent%"
		fi
	fi
}


loop-desktop() {
	while :; do
	echo "%{l}%{A1:urxvt -name popup -e ncmpcpp -p 6600 &:}%{A3:mpc toggle &:}$a0$p$(desktops)$p%{A}%{A}%{A:cover.sh &:}$a1$(song)%{A}$(window)$bg\
		 %{c}$p%{A:calendar.sh &:}$(clock)%{A}$p\
		%{r}$a2$p$(weather)$p$a0$p$(sound)$p$bg"
		sleep ".2s"
	done |\
	
	lemonbar \
	    -f '-x-terminus-*' \
	    -f '-wuncon-siji-*' \
	    -g "x30" \
	    | bash
}

loop-laptop() {
	while :; do
	echo "%{l}\
		$a2$af1%{A1:urxvt -name popup -e ncmpcpp -p 6600 &:}%{A3:mpc -p 6600 toggle &:}$p$(workspace)$p%{A}%{A}$txt$bg\
		$a2$af1%{A:/usr/scripts/cover.sh d &:}$(song)%{A}$bg\
		$p$af1$(window)$bg\
		$af1%{c}$(clock)$bg\
		%{r}\
		$af1%{A:/usr/scripts/weather.sh:}$p$(weather)$p%{A}$bg\
		$a2$af1$p$(network)$p$bg\
		$a2$af1$p$(sound)$p$bg\
		$a2$af1$p$(battery)$p$bg\
		"
		sleep ".2s"
	done |\
	
	lemonbar \
	    -f 'Terminus (ttf):size=9' \
	    -f 'Wuncon Siji:size=9' \
	    -g "x30" \
	    -b \
	    | bash
}

	loop-laptop "$@"
