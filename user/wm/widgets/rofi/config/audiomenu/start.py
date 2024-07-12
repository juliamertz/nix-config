#!/usr/bin/env python3

theme = "~/.config/rofi/audiomenu/theme.rasi"
input_label = "Output:"
history_file = "~/.config/rofi/audiomenu/.history"

import subprocess
import sys
import os

def cmd(cmd):
    return subprocess.check_output(cmd).decode("utf-8").strip()

def get_sinks():
    query = cmd(["pamixer", "--list-sinks"]).split("\n")
    query.pop(0)
    sinks = []
    for line in query:
        split = line.split(' ')[4:len(line.split(' '))]
        device_id = line.split(' ')[1].replace('"', '')

        name = " ".join(split)[0:len(" ".join(split))-1]
        sinks.append([name, device_id])

    return sinks

def run_rofi():
    sinks = get_sinks()
    sinks.reverse()
    joined_sinks = "\n".join(map(lambda sink: sink[0], sinks))

    try:
        ps = subprocess.Popen(('echo', '-e', joined_sinks), stdout=subprocess.PIPE)
        output = subprocess.check_output(('rofi', '-dmenu', '-i', '-theme', theme, '-p', input_label), stdin=ps.stdout)
        ps.wait()
    except subprocess.CalledProcessError:
        sys.exit(0)

    choice = output.decode("utf-8").strip()
    
    for sink in sinks:
        if choice == sink[0]:
            return sink[1]

def select_sink(sink):
    cmd(["pactl", "set-default-sink", sink])

chosen_output_device = run_rofi()
select_sink(chosen_output_device)
write_history(chosen_output_device)