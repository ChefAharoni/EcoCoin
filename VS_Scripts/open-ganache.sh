#!/bin/bash
if [[ "$OSTYPE" == "darwin"* ]]; then
    echo "Opening Ganache... "
    open -a Ganache
else
    echo "Please manually open Ganache on your computer."
fi

# Waits for the user to press enter, then continues.
read -p "Press enter to continue, AFTER you have started Ganache."

