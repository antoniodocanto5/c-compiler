%option yylineno

%{
	#include<stdio.h>
	#include"y.tab.h"
	#include<math.h>
%}
%%
"#include"([ ]+)?((<(\\.|[^>])+>)|(\"(\\.|[^"])+\"))					    {return HEADER;}
"#define"[ ]+[a-zA-z_][a-zA-z_0-9]* 							    {return DEFINE;}
"auto"|"register"|"static"|"extern"|"typedef"						    {return CONSTANTE_ARMAZENAMENTO;}
"void"|"char"|"short"|"int"|"long"|"float"|"double"|"signed"|"unsigned"			    {return CONSTANTE_TIPO;}	
"const"|"volatile"									    {return CONSTANTE_QUALIFICADOR;}
"enum"										            {return CONSTANTE_ENUMERADOR;}
"case"											    {return CASE;}	
"default"										    {return DEFAULT;}
"if"											    {return IF;}
"switch"										    {return SWITCH;}
"else"											    {return ELSE;}
"for"										            {return FOR;}
"do"											    {return DO;}
"while"											    {return WHILE;}
"goto"											    {return GOTO;}
"continue"										    {return CONTINUE;}
"break"											    {return BREAK;}
"struct"|"union"									    {return CONSTANTE_ESTRUTURA;}
"return"										    {return RETURN;}
"sizeof"										    {return SIZEOF;}
"||" 											    {return CONSTANTE_OU;}
"&&"											    {return CONSTANTE_E;}
"..."											    {return CONSTANTE_PARAMETRO;}
"=="|"!="										    {return CONSTANTE_IGUALDADE;}
"<="|">="										    {return CONSTANTE_RELACIONAL;}
">>"|"<<"										    {return CONSTANTE_SHIFT;}
"++"|"--"										    {return CONSTANTE_INCREMENTO;}
"->"											    {return CONSTANTE_PONTEIRO;}
";"|"="|","|"{"|"}"|"("|")"|"["|"]"|"*"|"+"|"-"|"/"|"?"|":"|"&"|"|"|"^"|"!"|"~"|"%"|"<"|">" {return yytext[0];}
"*="|"/="|"+="|"%="|">>="|"-="|"<<="|"&="|"^="|"|="					    {return COMP;}
[0-9]+											    {return CONSTANTE_INTEIRO;}
[0-9]+"."[0-9]+										    {return CONSTANTE_FLUTUANTE;}	
"'"."'"											    {return CONSTANTE_CARATERE;}
[a-zA-z_][a-zA-z_0-9]*			 						    {return ID;}
\"(\\.|[^\"])*\"									    {return STRING;}
"//"(\\.|[^\n])*[\n]									    ;
[/][*]([^*]|[*]*[^*/])*[*]+[/]                                                              ;
[ \t\n]										            ;
%%

int yywrap(void)
{
    return 1;
}
