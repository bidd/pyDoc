FUENTE = pydoc
PRUEBA = file.py

all: compile

compile:
	flex $(FUENTE).l
	bison -o $(FUENTE).tab.c $(FUENTE).y -yd
	gcc -w -o $(FUENTE) lex.yy.c $(FUENTE).tab.c -ll -ly

run:
	./$(FUENTE) < $(PRUEBA)

clean:
	rm $(FUENTE) lex.yy.c $(FUENTE).tab.c $(FUENTE).tab.h
