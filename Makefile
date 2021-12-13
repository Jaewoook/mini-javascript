SOURCE_PREFIX=mini-javascript
OUTPUT=javascript
LEX=flex
YACC=bison
LEX_OUTPUT=lex.yy.c
YACC_OUTPUT=y.tab.c y.tab.h
YACC_OUTPUT_DEBUG=d-y.tab.c d-y.tab.h
PARSER=parser
CC=gcc
CCFLAGS=-std=c17 -W -ly -ll -o
BISONFLAGS=-td -b

all: $(OUTPUT) debug

${OUTPUT}: ${LEX_OUTPUT} ${YACC_OUTPUT}
	${CC} -DYYDEBUG=0 ${CCFLAGS} ${OUTPUT} ${PARSER}.c

debug: ${LEX_OUTPUT} ${YACC_OUTPUT_DEBUG}
	${CC} -DYYDEBUG=1 ${CCFLAGS} ${OUTPUT}-debug ${PARSER}.c

${LEX_OUTPUT}: ${SOURCE_PREFIX}.l
	flex ${SOURCE_PREFIX}.l

${YACC_OUTPUT}: ${SOURCE_PREFIX}.y
	bison ${BISONFLAGS} y ${SOURCE_PREFIX}.y

$(YACC_OUTPUT_DEBUG): $(SOURCE_PREFIX).y
	bison -gr all $(BISONFLAGS) d-y $(SOURCE_PREFIX).y

clean:
	rm ${LEX_OUTPUT} ${YACC_OUTPUT} ${YACC_OUTPUT_DEBUG}
	rm ${OUTPUT} ${OUTPUT}-debug *y.output *y.vcg