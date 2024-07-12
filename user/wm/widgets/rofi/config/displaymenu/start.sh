#!/usr/bin/env sh

DAYTIME=""
SUNSET=""
NIGHTTIME=""

CHOICE=$(
    echo -e "$DAYTIME\n$SUNSET\n$NIGHTTIME" | \
    rofi -dmenu \
		 -p "Uptime: $uptime" \
		 -theme "$HOME/.config/rofi/displaymenu/theme.rasi"
)

if [[ $CHOICE == $DAYTIME ]]; then
    gummy -t 6500 -b 100
elif [[ $CHOICE == $SUNSET ]]; then
    gummy -t 4200 -b 100
elif [[ $CHOICE == $NIGHTTIME ]]; then
    gummy -t 3400 -b 60
fi

