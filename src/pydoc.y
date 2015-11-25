%{

/*
	==== TODO ====
	-Make the name of the file read the title of the html main page.
	-Make the name of the function the html function page.
	-Read the imports in the python file and show them in the html main page to indicate dependencies.
	-Find a way to add linejumps to examples:
		-If \n can not be changed to <br> then indicate that at the end of each line <br> should be added.
	-Give examples a css style with its own background to make them more easily readable
*/

#include <stdio.h>
#include <string.h>
#include "html_template.c"

extern int yylineno;
extern FILE * yyin;

void yyerror (char const *);

struct param{
	char type[20];
	char descr[100];
};

struct fun{
	char summary[50];
	int param_count;
	struct param params[10];
	char descr[100];
	int ex_count;
	char ex[3][100];
	char header[100];
};

struct x{
	char *s;
	int n;
};

struct fun funs[10];
fun_count = 0;

%}

%union{
	char* valString;
	struct x valX;
}

/*%error-verbose*/

%token <valString>	PARAM_SENTENCE DESCRIPTION HEADER
%token <valX>			SUMMARY PARAM_TYPE EXAMPLE
%type <valString>		params examples
%start S

%%

S : SUMMARY params DESCRIPTION examples HEADER	S			{ strcpy( funs[$1.n].summary, $1.s);
																			strcpy( funs[$1.n].descr, $3);
																			strcpy( funs[$1.n].header, $5);
																			fun_count++;}
	| SUMMARY params examples HEADER 							{ strcpy( funs[$1.n].summary, $1.s);
																			strcpy( funs[$1.n].header, $4);
																			fun_count++;}
	| error params examples HEADER S								{ yyerror("Error: please include at least a brief summary\n");}
	|																		{;}
	;

params :	PARAM_TYPE PARAM_SENTENCE params
						{ strcpy( funs[$1.n].params[funs[$1.n].param_count].type, $1.s);
						strcpy( funs[$1.n].params[funs[$1.n].param_count].descr, $2);
						funs[$1.n].param_count++;}
	|																		{;}
	;

examples : 	EXAMPLE examples				{ strcpy( funs[$1.n].ex[funs[$1.n].ex_count], $1.s);
													funs[$1.n].ex_count++;}
			|																{;}
	;

%%

void htmlHeader( FILE *fp){
	fprintf( fp, html_header);

}

void htmlFooter( FILE *fp){
	fprintf( fp, html_footer);
}

int htmlFunctionOutput( struct fun f){
	char aux[40];
	FILE *fp = NULL;

	sprintf( aux, "%s.html", f.header);

	fp = fopen( aux, "w");
	if (fp == NULL){
		return -1;
	}

	htmlHeader( fp);
	fprintf( fp, "<p>%s - %s</p>\
		<p>%s</p>\n", f.header, f.summary, f.descr);

	fprintf( fp, "\
		<table id = \"table1\">\n");
	while (f.param_count > 0){
		f.param_count--;
		fprintf(fp, "\
			<tr>\n\
				<td>%s</td>\n\
				<td>%s</td>\n\
			</tr>\n", f.params[f.param_count].type, f.params[f.param_count].descr);
	}
	fprintf( fp, "\
		</table>");

	while (f.ex_count > 0){
		f.ex_count--;
		fprintf( fp, "Example<br><code>%s</code><br>\n", f.ex[f.ex_count]);
	}

	htmlFooter( fp);
	fclose( fp);
}

int htmlOutput( char *filename){
	char name[40];
	snprintf( name, 40, "%s.html", filename);
	FILE *fp = fopen( name, "w");
	if (fp == NULL)
		return -1;

	FILE *fp2 = NULL;

	int aux_fun_count = fun_count;

	htmlHeader( fp);

	struct fun f;
	fprintf( fp, "\
		<table id=\"table1\">\n\
			<tr>\n\
				<th>FUNCTION</th>\n\
				<th>DESCRIPTION</th>\n\
			</tr>\n");

	while (aux_fun_count > 0){
		aux_fun_count--;
		f = funs[aux_fun_count];

		fprintf( fp, "\
		  <tr>\n\
		    <td><a href=\"%s.html\">%s</a></td>\n\
		    <td>%s</td>\n\
		  </tr>\n", f.header, f.header, f.summary);

		htmlFunctionOutput( f);
	}
	fprintf( fp, "		</table>\n");

	htmlFooter( fp);

	fclose( fp);
}

int main( int argc, char *argv[]) {

	if (argc < 2) {
		printf("No file specified");
		return -1;
	} else {
		int i = 1;
		while (i < argc){
			FILE *file = fopen( argv[i], "r");
			if (file == NULL)
				printf("Couldn't open file %s\n", argv[i]);
			else {
				yyin = file;
				yyparse();
				htmlOutput( argv[i]);
			}
			i++;
		}
	}

	return 0;
}

void yyerror (char const *message) {
	if ( strcmp(message,"syntax error") != 0) {
		printf("%s", message);
	}
}
