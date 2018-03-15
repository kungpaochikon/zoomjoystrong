%{
  #include <stdio.h>
  #include "zoomjoystrong.tab.h"
  #include "zoomjoystrong.h" 
  void yyerror(const char* msg);
  int yylex();
  int width = 1024;
  int height = 768;
%}

%error-verbose
%start statement_list

%union {int i; float f;}

%token	END
%token	END_STATEMENT
%token	POINT
%token	LINE
%token	CIRCLE
%token	RECTANGLE
%token	SET_COLOR
%token	INT
%token	FLOAT

%type<i> INT
%type<f> FLOAT

%%

statement_list: statement
  | statement statement_list
  ;

statement:  ex_line
  |	    ex_point
  |	    ex_circle
  |	    ex_rectangle
  |	    ex_set_color
  ;

ex_line: LINE INT INT INT INT END_STATEMENT
{
  //Make sure each point is in bounds
  if($2 <= width && $4 <= width && $2 >=0 && $4 >=0 && $3 <= height && $5 <= height && $3 >= 0 && $5 >= 0){
    line($2, $3, $4, $5);
  }
  else{
    yyerror("Values out of range");
  }
}
;

ex_point: POINT INT INT END_STATEMENT
{
  //Check if in screen
  if($2 <= width && $2 >= 0 && $3 <= height && $3 > 0){
    point($2,$3);
  }
  else{
    yyerror("Values out of range");
  }
}
;

ex_circle: CIRCLE INT INT INT END_STATEMENT
{
  //Check bounds with radius
  if($2 + $4 <= width && $3 + $4 <= height && $2 - $4 >= 0 && $3 - $4 >= 0){
    circle($2,$3,$4);
  }
  else{
    yyerror("Values out of range");
  }
}
;

ex_rectangle: RECTANGLE INT INT INT INT END_STATEMENT
{
  //Check if in given bounds
  if($2 >= 0 && $3 >= 0 && $2 + $4 <= width && $3 + $5 <= height){
    rectangle($2,$3,$4,$5);
  }
  else{
    yyerror("Values out of range");
  }
}
;

ex_set_color: SET_COLOR INT INT INT END_STATEMENT
{
  //Check color value in range 0-255
  if($2>=0 && $2<=255 && $3>=0 && $3<=255 && $4>=0 && $4<=255){
    set_color($2,$3,$4);
  }
  else{
    yyerror("Values out of range 0 - 255");
  }
}
;

%%

int main(){

  setup();
  yyparse();
  finish();
}

void yyerror(const char* msg){
  fprintf(stderr, "ERROR:%s\n",msg);
}


