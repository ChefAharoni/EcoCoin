#!/bin/bash
osascript -e 'tell application "Visual Studio Code" to activate' -e 'tell application "System Events" to keystroke "\\" using command down'

echo "Please switch to the terminal window that will run anvil."
echo "Please type 'make anvil' in the terminal window that will run anvil.\n\n"

read -p "Press enter to continue "

# code --command "workbench.action.terminal.split"