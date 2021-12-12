#!/bin/bash
echo "mini-javascript test script"
echo

BINARY=./javascript
if [ ! -f $BINARY ]; then
    echo "Error: binary not found"
    echo "run make command before test!"
    exit
fi

echo "Test variable declaration"
$BINARY samples/variable.js

echo
echo "Test condition statements"
$BINARY samples/condition.js

echo
echo "Test iteration stastements"
$BINARY samples/iteration.js

echo
echo "Test unary expressions"
$BINARY samples/unary.js

echo
echo "Test strict mode"
$BINARY samples/use_strict.js

echo
echo "Test error file"
$BINARY samples/err.js

echo
echo "Test simple javascript source"
$BINARY samples/simple.js