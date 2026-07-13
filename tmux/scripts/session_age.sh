#!/bin/sh
# prints elapsed time since $1 (unix timestamp), e.g. "2h 15m" or "3d 1h"
created=$1
now=$(date +%s)
s=$((now - created))
d=$((s / 86400))
h=$(((s % 86400) / 3600))
m=$(((s % 3600) / 60))

if [ "$d" -gt 0 ]; then
  printf '%dd %dh %dm' "$d" "$h" "$m"
elif [ "$h" -gt 0 ]; then
  printf '%dh %dm' "$h" "$m"
else
  printf '%dm' "$m"
fi
