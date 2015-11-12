%{
#include <stdlib.h>
#include "pydoc.tab.h"


int pydoc = 0;
%}

   /* === States === */
%x PYDOC_STATE
%x SUMMARY_STATE
%x PARAMS_STATE
%x DESCRIPTION_STATE
%x EXAMPLE_STATE

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

{opening}                                 { BEGIN PYDOC_STATE;}

<PYDOC_STATE>{summary_tag}                { printf("BEGIN SUMMARY\n"); BEGIN SUMMARY_STATE;}
<PYDOC_STATE>{params_tag}                 { printf("BEGIN PARAMS\n"); BEGIN PARAMS_STATE;}
<PYDOC_STATE>{description_tag}            { printf("BEGIN DESCRIPTION\n"); BEGIN DESCRIPTION_STATE;}
<PYDOC_STATE>{example_tag}                { printf("BEGIN EXAMPLE\n"); BEGIN EXAMPLE_STATE;}

<SUMMARY_STATE>{test}                     { printf("SUMMARY\n%s\n",yytext);
                                          BEGIN PYDOC_STATE;
                                          yylval.valString = strdup(yytext);
                                          return SUMMARY;}

<PARAMS_STATE>{param_word}                { printf("PARAM WORD\n%s\n",yytext);
                                          yylval.valString = strdup(yytext);
                                          return PARAM_WORD;}
<PARAMS_STATE>{double_linejump}           { BEGIN PYDOC_STATE;}
<PARAMS_STATE>{param_sentence}            { printf("PARAM SENTENCE\n%s\n",yytext);
                                          yylval.valString = strdup(yytext);
                                          return PARAM_SENTENCE;}

<DESCRIPTION_STATE>{test2}                { printf("DESCRIPTION\n%s\n",yytext);
                                          BEGIN PYDOC_STATE;
                                          yylval.valString = strdup(yytext);
                                          return DESCRIPTION;}

<EXAMPLE_STATE>{test2}                    { printf("EXAMPLE\n%s\n",yytext);
                                          BEGIN PYDOC_STATE;
                                          yylval.valString = strdup(yytext);
                                          return EXAMPLE;}

<PYDOC_STATE>{closing}                    { BEGIN INITIAL;}

"def"[^\n]+\n                             { printf("HEADER\n%s\n", yytext);
                                          yylval.valString = strdup(yytext);
                                          return HEADER;}

.                                         {;}
\n                                        {;}
EOF                                       {;}

%%
/*
int main(){
   yylex();
   return 0;
}
*/
