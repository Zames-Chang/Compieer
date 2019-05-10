/* Definition section */
%{
	#include <stdio.h>
	#include <stdlib.h>
	int num_lines = 0;
	int num_comments = 0;
	void printT(char *s){
		int len = strlen(yytext);
		for(int i=0 ;i<len;i++){
			if(yytext[i] != ' ' && yytext[i] != '\t') printf("%c",yytext[i]);
			
		}
		printf(" \t %s\n", s);
	}
%}

/* Define regular expression label */
letter [a-zA-Z]
digit [0-9]
id {letter}+({letter}|{digit})*
number {digit}+
comment "//"
floating_point {number}+"."+{number} 
space (" ")*

/* Rules section */
/* {strings} {printT("STR_CONST");} */
%%
	void comment_check(){
		int c;
		char comment[65535];
		comment[0] = '/';
		comment[1] = '*';
		int n = 1;
		while((c = input()) != 0){
			if(c == '\n') {
				++num_lines;
				++num_comments;
			}
			comment[++n] = (char) c;
		    if(c == '*'){
				if((c = input()) == '/'){
					comment[++n] = (char) c;
					++num_comments;
			        break;
				}
			else
			    unput(c);
			}
		}
		comment[++n] = '\0';
		printf("%s \t C Comment \n", comment);
	}
	void comment_check2(){
		int c;
		printf("//");
		while((c = input()) != 0 && c != '\n'){	
			printf("%c",c);
		} 
		if(c == '\n') {
			++num_comments;
			++num_lines;
		}
		printf(" \t C++ Comment\n");
	}
	void getString(){
		int c; 
		printT("QUOTA");
		while((c = input()) != 0 && c != '\"' && c != '\n') printf("%c",c);
		if(c == '\n') printf("error when parse string");
		printf(" \t STR_CONST\n");
		printT("QUOTA");
	}

"/*"			{comment_check();} 
{comment} 		{comment_check2();}
{space} {;}
"if"					{printT("IF"); }
"else"					{printT("ELSE");}
"while"					{printT("WHILE");}
"for"                   {printT("FOR");}
"print"				{printT("PRINT");}
"string"            {printT("STRING");}


"return"					{printT("RETURN");}
"void"					{printT("VOID");}
"int"					{printT("INT");}
"float"					{printT("FLOAT");}
"bool"					{printT("BOOL");}
"true"					{printT("TRUE");}
"false"					{printT("FALSE");}
"break"					{printT("BREAK");}


"="             {printT("ASGN");} 
"+="             {printT("ADDASGN");} 
"-="             {printT("SUBASGN");} 
"*="             {printT("MULASGN");}  
"/="             {printT("DIVASGN");} 
"%="             {printT("MODASGN");} 

"&&"            {printT("AND");} 
"||"            {printT("OR");}
"!"            {printT("NOT");}
"("            {printT("LB");}
")"            {printT("RB");}
"{"				{printT("LSB");}
"}"				{printT("RSB");}

"+"				{printT("ADD");}     
"-"				{printT("SUB");}     
"*"				{printT("MUL");}     
"/"				{printT("DIV");}
"%"             {printT("MOD");}
"++"				{printT("INC");} 
"--"				{printT("DEC");} 

">"				{printT("MT");}       
"<"				{printT("LT");}     
">="				{printT("MTE");} 
"<="				{printT("LTE");} 
"=="				{printT("EQ");} 
"!="				{printT("NE");}
","				{printT("COMMA");}
";"				{printT("SEMICOLON");}
"\""				{getString();}

{floating_point} {printT("F_CONST");}
{number} {printT("I_CONST");}
{id}	{ printT("ID"); }
\n			{num_lines++;}

%%

/*	C Code section */
int yywrap(void)
{
    return 1;
}

int main(int argc,char *argv[])
{
	yyin = fopen(argv[1],"r");
	yylex();
	printf("\nParse over, the line number is %d.\n",num_lines);
	printf("\ncomment: %d lines.\n",num_comments);
	return 0;
}
