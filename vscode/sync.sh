#!/bin/bash
set -e

CURRENT_DIR=`pwd`
if [[ $CURRENT_DIR != *"vscode"* ]]; then
  echo "Expect to run this script from the \"vscode\" directory, not \"${CURRENT_DIR}\". Exiting..."
  exit
fi

VSCODE_USER_DIR="C:/Users/${USERNAME}/AppData/Roaming/Code/User"
echo "VSCode user dir: ${VSCODE_USER_DIR}"
cp -f ${VSCODE_USER_DIR}/keybindings.json .
cp -f ${VSCODE_USER_DIR}/settings.json .
cp -f ${VSCODE_USER_DIR}/tasks.json .
