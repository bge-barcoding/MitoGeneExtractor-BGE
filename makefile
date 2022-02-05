# CFLAGS  = -g3 -ggdb -Wall
CFLAGS = -O2 -Wall

INCL =    -I .
#LIBS    = -lc -Wall

SRC    = MitoGeneExtractor.cpp \
	 global-types-and-parameters_MitoGeneExtractor.cpp

HEADER = CDnaString2.h CSequence_Mol2_1.h CSequences2.h CSplit2.h Ctriple.h \
         basic-DNA-RNA-AA-routines.h fast-realloc-vector.h faststring2.h \
         global-types-and-parameters_MitoGeneExtractor.h primefactors.h statistic_functions.h


all:    MitoGeneExtractor


MitoGeneExtractor: $(SRC) $(HEADER)
	g++ $(CFLAGS) $(INCL) $(SRC) -o MitoGeneExtractor


clean:
	rm -f MitoGeneExtractor

