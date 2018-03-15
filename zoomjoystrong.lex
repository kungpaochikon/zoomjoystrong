%{
  #include <stdlib.h>
  #include "zoomjoystrong.tab.h"
  void yyerror(char* msg);
  int fileno(FILE *stream);
%}

%option noyywrap

%%

end		{return END;}
;		{return END_STATEMENT;}
point		{return POINT;}
line		{return LINE;}
circle		{return CIRCLE;}
rectnagle	{return RECTANGLE;}
set_color	{return SET_COLOR;}
[0-9]+		{yylval.i = atoi(yytext); return INT;}
[0-9]*\.[0-9]+	{yylval.f = atof(yytext); return FLOAT;}
[" "|\t|\n]+	;//WHITESPACE

%%
