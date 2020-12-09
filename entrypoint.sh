
#Ports to be forwarded from IPv6 to IPv4
T6PORTS=($(echo $PORTS | tr ',' ' '))

# Interval at which the processes are checked
T6INTERVAL=${INTERVAL:-10m}

# Binary
T6BIN="6tunnel"

$T6BIN -p /tmp/6tunnel.pid -4 -f 443 $DST 443 -v
