#!/bin/bash
#
# This is a script for use in crontab.
#
# Author: Sandro Lutz <code@temparus.ch>


# ------------------------------------------------------
# Configuration section
# ------------------------------------------------------

#Ports to be forwarded from IPv6 to IPv4
T6PORTS=($(echo $PORTS | tr ',' ' '))

# Interval at which the processes are checked
T6INTERVAL=${INTERVAL:-10m}

# Binary
T6BIN="6tunnel"

# ------------------------------------------------------
# Function: get the 6tunnel PID file for the given port
# Params: $1 port number
# Return: string containing file path
# ------------------------------------------------------
function get_6tunnel_pid_file {
  echo "/tmp/6tunnel_port$1.pid"
}

# ------------------------------------------------------
# Function: checks if the forwarding process for the given port is running
# Params: $1 port number
# Return: successful if process is running correctly (return code 0)
# ------------------------------------------------------
function is_6tunnel_running {
  local pid_file=$(get_6tunnel_pid_file $1)
  if test -r $pid_file; then
    local pid=$(cat $pid_file)
    if $(kill -CHLD $pid >/dev/null 2>&1)
    then
      return 0 # 0 = true
    fi
    echo ""
    echo "erasing old PID file for port $1"
    rm -f $pid_file
  fi
  return 1 # 1 = false
}

# ------------------------------------------------------
# Function: starts the forwarding process for the given port
# Params: $1 port number
# Return: successful if process has been started successfully (return code 0)
# ------------------------------------------------------
function start_6tunnel_process {
  local pid_file=$(get_6tunnel_pid_file $1)
    # Redirect IPv4 to IPv6
    # https://serverfault.com/questions/276515/use-iptables-to-forward-ipv6-to-ipv4
    #$T6BIN -p $pid_file -4 $1 $DST -6 $1
    $T6BIN -p $pid_file -4 -f $1 $DST $1 -v
    return 0 # 0 = true
}

# ------------------------------------------------------
# Endless loop to check regularly if the processes are still running.
# ------------------------------------------------------
while /bin/true; do
  # ------------------------------------------------------
  # Loop through ports and ensure that 6tunnel is running.
  # ------------------------------------------------------
  for i in "${T6PORTS[@]}"
  do
    echo $i
    if is_6tunnel_running $i; then
      echo "6tunnel: [Port: $i, Status: running]"
    else
      echo "6tunnel: [Port: $i, Status: restarting]"
      start_6tunnel_process $i
      if is_6tunnel_running $i; then
        echo "6tunnel: [Port: $i, Status: running]"
        echo ""
      else
        >&2 echo "6tunnel: [Port: $i, Status: failed]"
        echo ""
      fi
    fi
  done
  sleep $T6INTERVAL
done
