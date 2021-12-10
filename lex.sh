#!/bin/bash
flex mini-javascript.l
gcc -o javascript lex.yy.c