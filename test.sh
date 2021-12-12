#!/bin/bash
echo "mini-javascript test script"

BINARY=./javascript
if [ ! -f $BINARY ]; then
    echo "Error: binary not found"
    echo "run make command before test!"
    exit
fi

SAMPLE_DIR=./samples
SUCCESS=0
ERROR=0
for SRC in "$SAMPLE_DIR"/*.js
do
    if [ -f $SRC ]
    then
        echo -e "\nTest $SRC"
        $BINARY $SRC

        if [ $? = 0 ]
        then
            ((SUCCESS++))
        else
            ((ERROR++))
        fi
    fi
done

echo "Result: $SUCCESS success, $ERROR error"