%{
#include <stdio.h>

extern int yylineno;

void yyerror (char const *);
%}

%union{
	float valFloat;
	char* valString;
}

/*%error-verbose*/
%token <valString> 	SHORT_DESCRIPTION HEADER_FUNCTION
%type <valString>		params
%start S

%%

S : 	SHORT_DESCRIPTION HEADER_FUNCTION
	| 	SHORT_DESCRIPTION params FUNCTION
	;

params : 	param_thingy										{printf("")}
			|	param_thingy param_thingy
			|	param_thingy param_thingy param_thingy
