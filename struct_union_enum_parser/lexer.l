%{
#include "parser.tab.h"
#include "lib.h"
#include <string.h>
%}

%option yylineno
%option noyywrap

DIGIT       [0-9]
LETTER      [a-zA-Z_]
IDENT       {LETTER}({LETTER}|{DIGIT})*
NAT         {DIGIT}+
WHITESPACE  [ \t\n\r]

%%

{WHITESPACE}        { /* ignore whitespace */ }

"struct"            { return STRUCT; }
"union"             { return UNION; }
"enum"              { return ENUM; }
"typedef"           { return TYPEDEF; }
"int"               { return INT; }
"char"              { return CHAR; }

{IDENT}             { yylval.str = new_str(yytext, yyleng); return IDENT; }
{NAT}               { yylval.nat = build_nat(yytext, yyleng); return NAT; }

"{"                 { return LBRACE; }
"}"                 { return RBRACE; }
";"                 { return SEMICOLON; }
","                 { return COMMA; }
"*"                 { return STAR; }
"["                 { return LBRACKET; }
"]"                 { return RBRACKET; }
"("                 { return LPAREN; }
")"                 { return RPAREN; }

.                   { /* ignore unknown characters */ }

%%
