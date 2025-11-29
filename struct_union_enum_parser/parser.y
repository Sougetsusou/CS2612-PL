%{
#include <stdio.h>
#include <stdlib.h>
#include "lang.h"

int yylex();
void yyerror(const char * s);

struct glob_item_list * root = NULL;

%}

%union {
  char * str;
  unsigned int nat;
  struct type_list * type_list;
  struct enum_ele_list * enum_ele_list;
  struct left_type * left_type;
  struct var_decl_expr * var_decl_expr;
  struct glob_item * glob_item;
  struct glob_item_list * glob_item_list;
}

%token STRUCT UNION ENUM TYPEDEF INT CHAR
%token LBRACE RBRACE SEMICOLON COMMA STAR LBRACKET RBRACKET LPAREN RPAREN
%token <str> IDENT
%token <nat> NAT

%type <type_list> field_list field_list_nonempty param_type_list
%type <enum_ele_list> enum_ele_list_nonempty
%type <left_type> left_type struct_or_union_specifier enum_specifier
%type <var_decl_expr> named_right_type_expr annon_right_type_expr
%type <glob_item> glob_item
%type <glob_item_list> glob_item_list

%start program

%%

program
    : glob_item_list
        { root = $1; }
    ;

glob_item_list
    : glob_item
        { $$ = TGCons($1, TGNil()); }
    | glob_item_list glob_item
        { $$ = TGCons($2, $1); }
    ;

glob_item
    : struct_or_union_specifier SEMICOLON
        {
            if ($1->t == T_STRUCT_TYPE) {
                $$ = TStructDecl($1->d.STRUCT_TYPE.name);
            } else if ($1->t == T_NEW_STRUCT_TYPE) {
                $$ = TStructDef($1->d.NEW_STRUCT_TYPE.name, $1->d.NEW_STRUCT_TYPE.fld);
            } else if ($1->t == T_UNION_TYPE) {
                $$ = TUnionDecl($1->d.UNION_TYPE.name);
            } else {
                $$ = TUnionDef($1->d.NEW_UNION_TYPE.name, $1->d.NEW_UNION_TYPE.fld);
            }
        }
    | enum_specifier SEMICOLON
        {
            if ($1->t == T_ENUM_TYPE) {
                $$ = TEnumDecl($1->d.ENUM_TYPE.name);
            } else {
                $$ = TEnumDef($1->d.NEW_ENUM_TYPE.name, $1->d.NEW_ENUM_TYPE.ele);
            }
        }
    | TYPEDEF left_type named_right_type_expr SEMICOLON
        { $$ = TTypeDef($2, $3); }
    | left_type named_right_type_expr SEMICOLON
        { $$ = TVarDef($1, $2); }
    ;

struct_or_union_specifier
    : STRUCT IDENT
        { $$ = TStructType($2); }
    | STRUCT IDENT LBRACE field_list RBRACE
        { $$ = TNewStructType($2, $4); }
    | STRUCT LBRACE field_list RBRACE
        { $$ = TNewStructType(NULL, $3); }
    | UNION IDENT
        { $$ = TUnionType($2); }
    | UNION IDENT LBRACE field_list RBRACE
        { $$ = TNewUnionType($2, $4); }
    | UNION LBRACE field_list RBRACE
        { $$ = TNewUnionType(NULL, $3); }
    ;

field_list
    : /* empty */
        { $$ = TTNil(); }
    | field_list_nonempty
        { $$ = $1; }
    ;

field_list_nonempty
    : left_type named_right_type_expr SEMICOLON
        { $$ = TTCons($1, $2, TTNil()); }
    | field_list_nonempty left_type named_right_type_expr SEMICOLON
        { $$ = TTCons($2, $3, $1); }
    ;

enum_specifier
    : ENUM IDENT
        { $$ = TEnumType($2); }
    | ENUM IDENT LBRACE enum_ele_list_nonempty RBRACE
        { $$ = TNewEnumType($2, $4); }
    | ENUM LBRACE enum_ele_list_nonempty RBRACE
        { $$ = TNewEnumType(NULL, $3); }
    ;

enum_ele_list_nonempty
    : IDENT
        { $$ = TECons($1, TENil()); }
    | enum_ele_list_nonempty COMMA IDENT
        { $$ = TECons($3, $1); }
    ;

left_type
    : struct_or_union_specifier
        { $$ = $1; }
    | enum_specifier
        { $$ = $1; }
    | INT
        { $$ = TIntType(); }
    | CHAR
        { $$ = TCharType(); }
    | IDENT
        { $$ = TDefinedType($1); }
    ;

named_right_type_expr
    : IDENT
        { $$ = TOrigType($1); }
    | STAR named_right_type_expr
        { $$ = TPtrType($2); }
    | named_right_type_expr LBRACKET NAT RBRACKET
        { $$ = TArrayType($1, $3); }
    | named_right_type_expr LPAREN param_type_list RPAREN
        { $$ = TFuncType($1, $3); }
    | LPAREN named_right_type_expr RPAREN
        { $$ = $2; }
    ;

annon_right_type_expr
    : STAR annon_right_type_expr
        { $$ = TPtrType($2); }
    | annon_right_type_expr LBRACKET NAT RBRACKET
        { $$ = TArrayType($1, $3); }
    | annon_right_type_expr LPAREN param_type_list RPAREN
        { $$ = TFuncType($1, $3); }
    | LPAREN annon_right_type_expr RPAREN
        { $$ = $2; }
    | /* empty */
        { $$ = NULL; }
    ;

param_type_list
    : /* empty */
        { $$ = TTNil(); }
    | left_type annon_right_type_expr
        { $$ = TTCons($1, $2, TTNil()); }
    | left_type annon_right_type_expr COMMA param_type_list
        { $$ = TTCons($1, $2, $4); }
    ;

%%

void yyerror(const char * s) {
    fprintf(stderr, "Error: %s\n", s);
}
