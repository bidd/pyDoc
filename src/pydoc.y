%{
#include <stdio.h>

extern int yylineno;

void yyerror (char const *);
%}

%union{
	char* valString;
}

%error-verbose

%token <valString>	SUMMARY PARAM_WORD PARAM_SENTENCE DESCRIPTION EXAMPLE HEADER
%type <valString>		params examples
%start S

%%

S : SUMMARY params DESCRIPTION examples HEADER					{;}
	;

params :	PARAM_WORD PARAM_WORD PARAM_SENTENCE					{;}
			| PARAM_WORD PARAM_WORD PARAM_SENTENCE params		{;}
	;

examples : 	EXAMPLE examples											{;}
			|	EXAMPLE														{;}
	;

%%
/*
int main() {
	yyparse();
	return 0;
}
*/
