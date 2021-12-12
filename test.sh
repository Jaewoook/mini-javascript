#!/bin/bash
echo "mini-javascript test script"

BINARY=./javascript
if [ ! -f $BINARY ]; then
    echo "Error: binary not found"
    echo "run make command before test!"
    exit
fi

SAMPLE_DIR=./samples
for SRC in "$SAMPLE_DIR"/*.js
do
    if [ -f $SRC ]; then
        echo -e "\nTest $SRC"
        $BINARY $SRC
    fi
done