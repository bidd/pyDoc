%{
#include <stdlib.h>

int pydoc = 0;
%}

%x PYDOC
%x SUMMARY
%x PARAMS
%x DESCRIPTION
%x EXAMPLE

   /* === Opening/closing === */
opening           '''pydoc
closing           '{3}

   /* === Function header === */
function          ^def.*\n

   /* ===  === */
example           "#ex"
long_descr        [^{closing}{example}]
word              [^ \t\n]+\t
sentence          [^\t\n]+
short_description [^{closing}@]+


summary_tag       (?i:#summary)
params_tag        (?i:#params)
description_tag   (?i:#description)
example_tag       (?i:#example)

double_linejump   \n{2}
test              [^\n]*
test2             [^#]*#\n\n
%%

{opening}                           { printf("ENTER PYDOC\n"); BEGIN PYDOC;}

<PYDOC>{summary_tag}                { printf("ENTER SUMMARY\n"); BEGIN SUMMARY;}
<PYDOC>{params_tag}                 { printf("ENTER PARAMS\n"); BEGIN PARAMS;}
<PYDOC>{description_tag}            { printf("ENTER DESCRIPTION\n"); BEGIN DESCRIPTION;}
<PYDOC>{example_tag}                { printf("ENTER EXAMPLE\n"); BEGIN EXAMPLE;}

<SUMMARY>{test}                     { printf("SUMMARY\n%s\n",yytext); BEGIN PYDOC;}

<PARAMS>{test}                      { printf("PARAM\n%s\n",yytext);}
<PARAMS>{double_linejump}           { BEGIN PYDOC;}

<DESCRIPTION>{test2}                { printf("DESCRIPTION\n%s\n",yytext); BEGIN PYDOC;}

<EXAMPLE>{test2}                     { printf("EXAMPLE\n%s\n",yytext); BEGIN PYDOC;}

<PYDOC>{closing}                    { printf("EXIT PYDOC\n"); BEGIN INITIAL;}

.
\n

%%

int main(){
   yylex();
   return 0;
}
