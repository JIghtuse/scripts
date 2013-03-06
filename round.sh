#!/bin/bash

# Weird script for moving mouse cursor by circle.
# I don't know why.
# Needs bc and xdotool for work.

center_x=683
center_y=384
radius=380
steps=30

pi=$(echo '4*a(1)' | bc -l)
step=$(echo "2*$pi/$steps" | bc -l)
rad=0

while true; do
    for i in $(seq $steps); do
        x=$(echo "scale=1; (c($rad)*$radius + $center_x)" | bc -l)
        y=$(echo "scale=1; (s($rad)*$radius + $center_y)" | bc -l)
        xdotool mousemove $x $y

        rad=$(echo "$rad + $step" | bc -l)
    done
done
