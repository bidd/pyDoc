%{
#include <stdio.h>
#include <string.h>

extern int yylineno;

void yyerror (char const *);

struct param{
	char name[30];
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

%error-verbose

%token <valString>	PARAM_TYPE PARAM_SENTENCE DESCRIPTION HEADER
%token <valX>			SUMMARY PARAM_NAME EXAMPLE
%type <valString>		params examples
%start S

%%

S : SUMMARY params DESCRIPTION examples HEADER	S			{ strcpy( funs[$1.n].summary, $1.s);
																			strcpy( funs[$1.n].descr, $3);
																			strcpy( funs[$1.n].header, $5);
																			fun_count++;}
	|																		{;}
	;

params :	PARAM_NAME PARAM_TYPE PARAM_SENTENCE params
						{ strcpy( funs[$1.n].params[funs[$1.n].param_count].name, $1.s);
						strcpy( funs[$1.n].params[funs[$1.n].param_count].type, $2);
						strcpy( funs[$1.n].params[funs[$1.n].param_count].descr, $3);
						funs[$1.n].param_count++;}
	|																		{;}
	;

examples : 	EXAMPLE examples				{ strcpy( funs[$1.n].ex[funs[$1.n].ex_count], $1.s);
													funs[$1.n].ex_count++;}
			|																{;}
	;

%%

/*
void print(){
	struct fun f;
	while (fun_count > 0){
		fun_count--;
		f = funs[fun_count];
		printf("%s\n%s\n", f.header, f.summary);
		while (f.param_count > 0){
			f.param_count--;
			printf("%s	%s	%s\n", f.params[f.param_count].name, f.params[f.param_count].type, f.params[f.param_count].descr);
		}
		printf("%s\n", f.descr);
		while (f.ex_count > 0){
			f.ex_count--;
			printf("%s\n", f.ex[f.ex_count]);
		}
		printf("===============\n===============\n");
	}
}*/

/*
<!DOCTYPE html>
<html>
<head>
<title>Page Title</title>
</head>
<body>

<h1>This is a Heading</h1>
<p>This is a paragraph.</p>

</body>
</html>
*/

void htmlHeader( FILE *fp){
	fprintf( fp, "\<!DOCTYPE html>\n\
	<html>\n\
	<head>\n\
	<title>Page Title</title>\n\
	</head>\n\
	<body>\n\
	\n");
}

void htmlFooter( FILE *fp){
	fprintf( fp, "\
	\n\
	</body>\n\
	</html>\
	");
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

	while (f.param_count > 0){
		f.param_count--;
		fprintf(fp, "\
		<table style=\"width:80%\">\n\
			<tr>\n\
				<td>%s</td>\n\
				<td>%s</td>\n\
				<td>%s</td>\n\
			</tr>\n", f.params[f.param_count].name, f.params[f.param_count].type, f.params[f.param_count].descr);
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

int htmlOutput(){
	FILE *fp = fopen( "index.html", "w");
	if (fp == NULL)
		return -1;

	FILE *fp2 = NULL;

	int aux_fun_count = fun_count;

	htmlHeader( fp);

	struct fun f;
	while (aux_fun_count > 0){
		aux_fun_count--;
		f = funs[aux_fun_count];

		fprintf( fp, "\
		<table style=\"width:80%\">\n\
		  <tr>\n\
		    <td><a href=\"%s.html\">%s</a></td>\n\
		    <td>%s</td>\n\
		  </tr>\n\
		</table>\n", f.header, f.header, f.summary);

		htmlFunctionOutput( f);
	}

	htmlFooter( fp);

	fclose( fp);
}

int main() {
	yyparse();
	//print();

	htmlOutput();

	return 0;
}
