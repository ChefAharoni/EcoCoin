#!/bin/bash

echo "Please switch to the terminal window that will run anvil."

read -p "Press enter to continue"

anvil -m 'test test test test test test test test test test test junk' --steps-tracing --block-time 1
