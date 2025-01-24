#!/bin/bash

# Effective root directory
ROOT_DIR="./"

echo "Touching all files and directories under $ROOT_DIR..."
find "$ROOT_DIR" -exec touch {} +

echo "Done."
