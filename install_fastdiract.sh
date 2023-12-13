#!/usr/bin/env bash
set -euo pipefail

if ! [ -f ~/fastdirs ]; then
    cat <<EOF > ~/fastdirs
d1 = ~/alpha
d2 = ~/beta
d3 = ~/gamma
d4 = ~/delta
d5 = ~/epsilon
d6 = ~/zeta
d7 = ~/eta
d8 = ~/theta
d9 = ~/iota
EOF
    echo "Creating fastdirs template"
else
    echo "fastdirs file already exists"
fi

if ! [ -f ~/fastactions ]; then
    cat <<EOF > ~/fastactions
f1 = echo alpha
f2 = echo beta
f3 = echo gamma
f4 = echo delta
f5 = echo epsilon
f6 = echo zeta
f7 = echo eta
f8 = echo theta
f9 = echo iota
EOF
    echo "Creating fastactions template"
else
    echo "fastactions file already exists"
fi
