# mini-javascript

A mini JavaScript parser using Lex & Yacc

## Prerequisites

- flex
- bison
- make
- gcc

## Setup

```sh
# compile all sources
$ make

# or you can compile lexer separately
$ ./lex.sh

# NOTE: if you can't run .sh file, run this command first
$ chmod +x *.sh
```

## Usage

```sh
$ ./javascript [FILE]
```

## Test

```sh
$ ./test.sh
```

## Author

- [Jaewook Ahn](https://github.com/Jaewoook)
