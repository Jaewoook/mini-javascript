#!/bin/bash
flex mini-javascript.l
bison -d mini-javascript.y
gcc -o javascript *.c