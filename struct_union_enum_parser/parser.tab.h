/* A Bison parser, made by GNU Bison 2.3.  */

/* Skeleton interface for Bison's Yacc-like parsers in C

   Copyright (C) 1984, 1989, 1990, 2000, 2001, 2002, 2003, 2004, 2005, 2006
   Free Software Foundation, Inc.

   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 2, or (at your option)
   any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program; if not, write to the Free Software
   Foundation, Inc., 51 Franklin Street, Fifth Floor,
   Boston, MA 02110-1301, USA.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* Tokens.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
   /* Put the tokens into the symbol table, so that GDB and other debuggers
      know about them.  */
   enum yytokentype {
     STRUCT = 258,
     UNION = 259,
     ENUM = 260,
     TYPEDEF = 261,
     INT = 262,
     CHAR = 263,
     LBRACE = 264,
     RBRACE = 265,
     SEMICOLON = 266,
     COMMA = 267,
     STAR = 268,
     LBRACKET = 269,
     RBRACKET = 270,
     LPAREN = 271,
     RPAREN = 272,
     IDENT = 273,
     NAT = 274
   };
#endif
/* Tokens.  */
#define STRUCT 258
#define UNION 259
#define ENUM 260
#define TYPEDEF 261
#define INT 262
#define CHAR 263
#define LBRACE 264
#define RBRACE 265
#define SEMICOLON 266
#define COMMA 267
#define STAR 268
#define LBRACKET 269
#define RBRACKET 270
#define LPAREN 271
#define RPAREN 272
#define IDENT 273
#define NAT 274




#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union YYSTYPE
#line 13 "parser.y"
{
  char * str;
  unsigned int nat;
  struct type_list * type_list;
  struct enum_ele_list * enum_ele_list;
  struct left_type * left_type;
  struct var_decl_expr * var_decl_expr;
  struct glob_item * glob_item;
  struct glob_item_list * glob_item_list;
}
/* Line 1529 of yacc.c.  */
#line 98 "parser.tab.h"
	YYSTYPE;
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
# define YYSTYPE_IS_TRIVIAL 1
#endif

extern YYSTYPE yylval;

