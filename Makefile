SOURCE_PREFIX=mini-javascript
OUTPUT=javascript
LEX=flex
YACC=bison
LEX_OUTPUT=lex.yy.c
YACC_OUTPUT=y.tab.c y.tab.h
CC=gcc
CCFLAGS=-std=c17 -W -ly -ll -o

all: ${OUTPUT}

${OUTPUT}: ${LEX_OUTPUT} ${YACC_OUTPUT}
	${CC} ${CCFLAGS} ${OUTPUT} y.tab.c

${LEX_OUTPUT}: ${SOURCE_PREFIX}.l
	flex ${SOURCE_PREFIX}.l

${YACC_OUTPUT}: ${SOURCE_PREFIX}.y
	bison -t -d -b y ${SOURCE_PREFIX}.y

clean:
	rm *.c
	rm *.h
	rm ${OUTPUT}