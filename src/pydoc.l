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
param_type        ^{word}
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
<SUMMARY_STATE>\n                         {}

<PARAMS_STATE>{param_type}                { yylval.valX.s = strdup(yytext);
                                          yylval.valX.n = i;
                                          return PARAM_TYPE;}
<PARAMS_STATE>{double_linejump}           { BEGIN PYDOC_STATE;}
<PARAMS_STATE>{param_sentence}            { yylval.valString = strdup(&yytext[1]);
                                          return PARAM_SENTENCE;}
<PARAMS_STATE>\n                          {}

<DESCRIPTION_STATE>{multi_line}           {BEGIN PYDOC_STATE;
                                          yylval.valString = strdup(&yytext[1]);
                                          return DESCRIPTION;}
<DESCRIPTION_STATE>\n                     {}

<EXAMPLE_STATE>{multi_line}               {BEGIN PYDOC_STATE;
                                          yylval.valX.s = strdup(yytext);
                                          yylval.valX.n = i;
                                          return EXAMPLE;}
<EXAMPLE_STATE>\n                         {}

<PYDOC_STATE>{closing}                    { BEGIN INITIAL;}
<PYDOC_STATE>\n                           {}

"def"[^(]+                                {yylval.valString = strdup(&yytext[4]);
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
