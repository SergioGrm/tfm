
CC=gcc
CFLAGS=-ansi -pedantic -Wall 
CXX=g++
CXXFLAGS=-Wall
MAKE_DIR=mkdir -p
PARSER=./parser.run

ANSWER_FILE=corrections/$(ANSWER_ID)/respuesta.txt
COMPILE_FILE=corrections/$(ANSWER_ID)/compile.c
OBJECT_FILE=corrections/$(ANSWER_ID)/compile.o
SOLUTION_FILE=corrections/$(ANSWER_ID)/solution.cpp
CORRECT_FILE=corrections/$(ANSWER_ID)/solution.run
ENUN_FILE=preguntas/$(QUESTION_ID).enu
SOL_FILE=preguntas/$(QUESTION_ID).sol

all: check

.PHONY: all

$(COMPILE_FILE): $(ANSWER_FILE)
	$(PARSER) $(ANSWER_FILE) $(ENUN_FILE) $(COMPILE_FILE)

$(SOLUTION_FILE): $(ANSWER_FILE)
	$(PARSER) $(ANSWER_FILE) $(SOL_FILE) $(SOLUTION_FILE)

$(OBJECT_FILE): $(COMPILE_FILE)
	$(CC) $(CFLAGS) -c $(COMPILE_FILE) -o $(OBJECT_FILE)
	
$(CORRECT_FILE): $(OBJECT_FILE) $(SOLUTION_FILE)
	$(CXX) $(CXXFLAGS) $(SOLUTION_FILE) -o $(CORRECT_FILE)

check: $(CORRECT_FILE)
	$(CORRECT_FILE)
