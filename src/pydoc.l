%{
#include <stdlib.h>
#include "pydoc.tab.h"


int pydoc = 0;
%}

   /* === States === */
%x PYDOC
%x SUMMARY
%x PARAMS
%x DESCRIPTION
%x EXAMPLE

   /* === Opening/closing === */
opening           '''pydoc
closing           '{3}

   /* === Tags === */
summary_tag       (?i:#summary)
params_tag        (?i:#params)
description_tag   (?i:#description)
example_tag       (?i:#example)

   /* === Aux === */
double_linejump   \n{2}
word              [^ \t\n]+
sentence          [^\t\n]+
param_word        \t{word}
param_sentence    \t{sentence}
test              [^\n]*
test2             [^#]*#\n\n

%%

{opening}                           { BEGIN PYDOC;}

<PYDOC>{summary_tag}                { printf("BEGIN SUMMARY\n"); BEGIN SUMMARY;}
<PYDOC>{params_tag}                 { printf("BEGIN PARAMS\n"); BEGIN PARAMS;}
<PYDOC>{description_tag}            { printf("BEGIN DESCRIPTION\n"); BEGIN DESCRIPTION;}
<PYDOC>{example_tag}                { printf("BEGIN EXAMPLE\n"); BEGIN EXAMPLE;}

<SUMMARY>{test}                     { printf("SUMMARY\n%s\n",yytext);
                                       BEGIN PYDOC;
                                       yylval.valString = strdup(yytext);
                                       return SUMMARY;}

<PARAMS>{param_word}                { printf("PARAM WORD\n%s\n",yytext);
                                       yylval.valString = strdup(yytext);
                                       return PARAM_WORD;}
<PARAMS>{double_linejump}           { BEGIN PYDOC;}
<PARAMS>{param_sentence}            { printf("PARAM SENTENCE\n%s\n",yytext);
                                       yylval.valString = strdup(yytext);
                                       return PARAM_SENTENCE;}

<DESCRIPTION>{test2}                { printf("DESCRIPTION\n%s\n",yytext);
                                       BEGIN PYDOC;
                                       yylval.valString = strdup(yytext);
                                       return DESCRIPTION;}

<EXAMPLE>{test2}                    { printf("EXAMPLE\n%s\n",yytext);
                                       BEGIN PYDOC;
                                       yylval.valString = strdup(yytext);
                                       return EXAMPLE;}

<PYDOC>{closing}                    { BEGIN INITIAL;}

"def"[^\n]+\n                       { printf("HEADER\n%s\n", yytext);
                                       yylval.valString = strdup(yytext);
                                       return HEADER;}

.                                   {}
\n                                  {}
EOF                                 {}

%%
/*
int main(){
   yylex();
   return 0;
}
*/
