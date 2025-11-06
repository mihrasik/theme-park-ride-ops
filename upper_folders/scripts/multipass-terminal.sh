#!/bin/bash

# Get the Multipass instance name (you can change default_instance to your instance name)
INSTANCE=${1:-park-project}

# Forward the command to multipass
if [ $# -gt 1 ]; then
    # If there are arguments, pass them to multipass exec
    shift
    multipass exec "$INSTANCE" -- "$@"
else
    # If no arguments, open an interactive shell
    multipass shell "$INSTANCE"
fi