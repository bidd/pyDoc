%{
#include <stdlib.h>
#include "x.h"
#include "pydoc.tab.h"


int pydoc = 0;
int i = 0;
%}

   /* === States === */
%x PYDOC_STATE
%x SUMMARY_STATE
%x PARAMS_STATE
%x DESCRIPTION_STATE
%x EXAMPLE_STATE

   /* === Opening/closing === */
opening           (?i:#pydoc)
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
param_name        ^{word}
param_type        \t{word}
param_sentence    \t{sentence}
single_line       [^\n]*
multi_line        [^#]*#\n\n

%%

{opening}                                 { BEGIN PYDOC_STATE;}

<PYDOC_STATE>{summary_tag}                { BEGIN SUMMARY_STATE;}
<PYDOC_STATE>{params_tag}                 { BEGIN PARAMS_STATE;}
<PYDOC_STATE>{description_tag}            { BEGIN DESCRIPTION_STATE;}
<PYDOC_STATE>{example_tag}                { BEGIN EXAMPLE_STATE;}

<SUMMARY_STATE>{single_line}              { BEGIN PYDOC_STATE;
                                          yylval.valX.s = strdup(yytext);
                                          yylval.valX.n = i;
                                          return SUMMARY;}

<PARAMS_STATE>{param_name}                { yylval.valX.s = strdup(yytext);
                                          yylval.valX.n = i;
                                          return PARAM_NAME;}
<PARAMS_STATE>{param_type}                { yylval.valString = strdup(&yytext[1]);
                                          return PARAM_TYPE;}
<PARAMS_STATE>{double_linejump}           { BEGIN PYDOC_STATE;}
<PARAMS_STATE>{param_sentence}            { yylval.valString = strdup(&yytext[1]);
                                          return PARAM_SENTENCE;}

<DESCRIPTION_STATE>{multi_line}           {BEGIN PYDOC_STATE;
                                          yylval.valString = strdup(&yytext[1]);
                                          return DESCRIPTION;}

<EXAMPLE_STATE>{multi_line}               {BEGIN PYDOC_STATE;
                                          yylval.valX.s = strdup(yytext);
                                          yylval.valX.n = i;
                                          return EXAMPLE;}

<PYDOC_STATE>{closing}                    { BEGIN INITIAL;}

"def"[^(]+                               {yylval.valString = strdup(&yytext[4]);
                                          i++;
                                          return HEADER;}

.                                         {}
\n                                        {}
EOF                                       {}

%%
/*
int main(){
   yylex();
   return 0;
}
*/
