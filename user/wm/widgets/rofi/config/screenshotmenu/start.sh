#!/usr/bin/env sh

SCREENSHOTS_DIR="$HOME/screenshots"
MONITOR_COUNT=$(xrandr --listactivemonitors | grep -v "Monitors:" | wc -l)
THEME="$HOME/.config/rofi/screenshotmenu/theme.rasi"

options=("Select Area" "Focused window")

get_filename() {
    echo "$SCREENSHOTS_DIR/$(date | tr ' ' '-').png"
}

join_by_string() {
  local separator="$1"
  shift
  local first="$1"
  shift
  printf "%s" "$first" "${@/#/$separator}"
}

run_rofi() {
    echo -e $1 | \
    rofi -dmenu \
         -p "Screenshot: " \
         -theme $THEME
}

generate_options() {
    # add option for each monitor
    for i in $(seq 1 $MONITOR_COUNT); do
        i=$(($i - 1))
        # U+2800 fixes an issue where it will be split into two lines
        opt="Monitor⠀$i"
        options+=($opt)
    done
}

generate_options

joined_options=$(join_by_string "\n" "${options[@]}")
choice=$(echo -e $(run_rofi "$joined_options"))

if [[ $choice == "Select Area" ]]; then
    scrot -s -F $(get_filename)
elif [[ $choice == "Focused window" ]]; then
    scrot -u -F $(get_filename)
elif [[ $choice = Monitor* ]]; then
    MONITOR_NUMBER=$(echo $choice | awk -F "⠀" '{print $2}')
    filename=$(get_filename)
    sleep 0.2
    scrot -M $MONITOR_NUMBER -F $filename
else
    echo "Invalid option"
    exit 1
fi
