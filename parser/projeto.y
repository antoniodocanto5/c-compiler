%{
	#include<stdio.h>
	int yylex(void);
	int yyerror(const char *s);
	int success = 1;
%}


%token   CONSTANTE_INTEIRO   CONSTANTE_CARATERE   CONSTANTE_FLUTUANTE   ID   STRING   CONSTANTE_ENUMERADOR CONSTANTE_ARMAZENAMENTO
%token 	 CONSTANTE_TIPO    CONSTANTE_QUALIFICADOR    CONSTANTE_ESTRUTURA   DEFINE   COMP   CONSTANTE_OU 
%token   IF   FOR   DO   WHILE   BREAK   SWITCH   CONTINUE   RETURN    CASE    DEFAULT    GOTO    SIZEOF  CONSTANTE_E 
%token   CONSTANTE_IGUALDADE     CONSTANTE_SHIFT    CONSTANTE_RELACIONAL  CONSTANTE_INCREMENTO
%token   CONSTANTE_PONTEIRO   CONSTANTE_PARAMETRO  ELSE  HEADER
%left '+' '-'
%left '*' '/'

%define parse.error verbose
%start programa
%%


programa :             					HEADER programa  {YYACCEPT;}                             
							| DEFINE expressao_primaria  programa {YYACCEPT;}                 	
							| forma {YYACCEPT;} ;									
							
forma : 						declaracao_externa 									
							| forma declaracao_externa;				
							
declaracao_externa : 					definicao_funcao
							| declaracao

definicao_funcao : 					especificador_declaracao      declarador    lista_declarador   estrutura_composta 	
							| declarador     lista_declarador    estrutura_composta
							| especificador_declaracao      declarador	estrutura_composta 				
							| declarador     estrutura_composta ;
							
declaracao :						especificador_declaracao    lista_declarador_de_inicializacao ';' 				
							| especificador_declaracao ';' ;
							

lista_declarador : 					declaracao
							| lista_declarador  declaracao ;
							

especificador_declaracao : 				especificador_de_armazenamento   especificador_declaracao
							| especificador_de_armazenamento 
							| especificador_de_tipo     especificador_declaracao								
							| especificador_de_tipo 										
							| qualificador_de_tipo      especificador_declaracao
							| qualificador_de_tipo ;
							

especificador_de_armazenamento :			CONSTANTE_ARMAZENAMENTO ;
							

especificador_de_tipo : 				CONSTANTE_TIPO										
							| especificador_de_struct_ou_union
							| especificador_de_enumerador
							| nome_typedef ;

							
qualificador_de_tipo : 					CONSTANTE_QUALIFICADOR ;


especificador_de_struct_ou_union : 			struct_ou_union ID '{' lista_decl_struct '}'
							| struct_ou_union '{' lista_decl_struct '}'
							| struct_ou_union ID ;
							

struct_ou_union	:  					CONSTANTE_ESTRUTURA ;
							

lista_decl_struct :  					decl_struct
							| lista_decl_struct   decl_struct ;

							
lista_declarador_de_inicializacao : 		 	declarador_de_inicializacao 
							| lista_declarador_de_inicializacao ',' declarador_de_inicializacao ;
							

declarador_de_inicializacao : 				declarador
							| declarador '=' inicializador ;

							
decl_struct :  						especificador_de_lista_de_qualificador   lista_declarador_struct ';' ;
							

especificador_de_lista_de_qualificador :  		especificador_de_tipo   especificador_de_lista_de_qualificador
							| especificador_de_tipo
							| qualificador_de_tipo   especificador_de_lista_de_qualificador
							| qualificador_de_tipo ;
							
lista_declarador_struct	:  				declarador_struct
							| lista_declarador_struct ',' declarador_struct ;
							

declarador_struct : 					 declarador
							| declarador ':' expressao_constante
							| ':' expressao_constante ;


especificador_de_enumerador : 				 CONSTANTE_ENUMERADOR   ID  '{' lista_enumerador '}'
							| CONSTANTE_ENUMERADOR '{' lista_enumerador '}'
							| CONSTANTE_ENUMERADOR   ID ;
							

lista_enumerador : 					enumerador
							| lista_enumerador ',' enumerador ;
							

enumerador : 						ID
							| ID '=' expressao_constante ;
							

declarador :						 ponteiro    declarador_direto
							| declarador_direto ;
							
declarador_direto:					 ID 												
							| '(' declarador ')'									
							| declarador_direto '[' expressao_constante ']'							
							| declarador_direto '['	']'
							| declarador_direto '(' lista_tipo_parametro ')' 			
							| declarador_direto '(' lista_identificador ')' 					
							| declarador_direto '('	')' ;


ponteiro : 						'*' lista_qualificador_tipo
							| '*'
							| '*' lista_qualificador_tipo  ponteiro
							| '*' ponteiro ;
							

lista_qualificador_tipo	: 				qualificador_de_tipo
							| lista_qualificador_tipo  qualificador_de_tipo ;
							

lista_tipo_parametro :					lista_parametro
							| lista_parametro ',' CONSTANTE_PARAMETRO ;
							

lista_parametro :					declaracao_de_parametro
							| lista_parametro ',' declaracao_de_parametro ;
							

declaracao_de_parametro :				especificador_declaracao    declarador
							| especificador_declaracao   declarador_abstrato
							| especificador_declaracao ;
							
lista_identificador :					ID
							| lista_identificador ',' ID ;


inicializador :					 	expressao_de_atribuicao
							| '{' lista_inicializador '}'
							| '{' lista_inicializador ',' '}' ;

							
lista_inicializador :					 inicializador
							| lista_inicializador ',' inicializador ;
							

nome_de_tipo : 						especificador_de_lista_de_qualificador   declarador_abstrato
							| especificador_de_lista_de_qualificador ;
							

declarador_abstrato :					 ponteiro
							| ponteiro   declarador_direto_abstrato
							| declarador_direto_abstrato ;
							

declarador_direto_abstrato : 				 '(' declarador_abstrato ')'
							| declarador_direto_abstrato '[' expressao_constante ']'
							| '[' expressao_constante ']'
							| declarador_direto_abstrato '[' ']'
							| '[' ']'
							| declarador_direto_abstrato '(' lista_tipo_parametro ')'
							| '(' lista_tipo_parametro ')'
							| declarador_direto_abstrato '(' ')'
							| '(' ')' ;


nome_typedef : 						't';
							
estrutura :						 estrutura_switch 									      	
							| estrutura_exp											  	
							| estrutura_composta 									  	
							| estrutura_if  									  
							| estrutura_iteracao
							| estrutura_goto ;
							

estrutura_switch :					 ID':' estrutura
							| CASE expressao_constante ':' estrutura
							| DEFAULT ':' estrutura ;
							

estrutura_exp :						 expressao ';'
							| ';' ;
							

estrutura_composta : 					'{' lista_declarador  lista_estrutura '}'   						
							| '{' lista_estrutura '}'										
							| '{' lista_declarador	'}'										
							| '{' '}' ;												
							

lista_estrutura	:					estrutura     												
							| lista_estrutura  estrutura ;										
		
					
estrutura_if :						IF '(' expressao ')' estrutura 									
							| IF '(' expressao ')' estrutura ELSE estrutura
							| SWITCH '(' expressao ')' estrutura ;
							

estrutura_iteracao				: WHILE '(' expressao ')' estrutura
							| DO estrutura WHILE '(' expressao ')' ';'
							| FOR '(' expressao ';' expressao ';' expressao ')'  estrutura
							| FOR '(' expressao ';' expressao ';'	')'  estrutura
							| FOR '(' expressao ';' ';' expressao ')'  estrutura
							| FOR '(' expressao ';' ';' ')'  estrutura
							| FOR '(' ';' expressao ';' expressao ')'  estrutura
							| FOR '(' ';' expressao ';' ')'  estrutura
							| FOR '(' ';' ';' expressao ')'  estrutura
							| FOR '(' ';' ';' ')'  estrutura ;
							
estrutura_goto :					 GOTO  ID ';'
							| CONTINUE ';'
							| BREAK ';'
							| RETURN  expressao ';'
							| RETURN ';' ;
							
expressao :						 expressao_de_atribuicao
							| expressao ','  expressao_de_atribuicao ;
							

expressao_de_atribuicao :				 expressao_condicional
							| expressao_unaria   operador_de_atribuicao   expressao_de_atribuicao ;	


operador_de_atribuicao :				 COMP
							| '=' ;
							

expressao_condicional : 				expressao_logica_ou
							| expressao_logica_ou '?' expressao ':' expressao_condicional ;
							

expressao_constante :					expressao_condicional;
							

expressao_logica_ou :					expressao_logica_e
							| expressao_logica_ou   CONSTANTE_OU  expressao_logica_e ;
							

expressao_logica_e :					expressao_inclusiva_ou
							| expressao_logica_e    CONSTANTE_E   expressao_inclusiva_ou ;
							

expressao_inclusiva_ou :				expressao_exclusiva_ou
							| expressao_inclusiva_ou '|' expressao_exclusiva_ou ;
							

expressao_exclusiva_ou : 				expressao_e
							| expressao_exclusiva_ou '^' expressao_e ;
							

expressao_e :						expressao_igualdade
							| expressao_e '&' expressao_igualdade ;
							
expressao_igualdade : 					expressao_relacional
							| expressao_igualdade CONSTANTE_IGUALDADE expressao_relacional ;
							

expressao_relacional :					 expressao_shift
							| expressao_relacional '<' expressao_shift
							| expressao_relacional '>' expressao_shift
							| expressao_relacional CONSTANTE_RELACIONAL expressao_shift ;
							

expressao_shift	:					expressao_adicao
							| expressao_shift CONSTANTE_SHIFT expressao_adicao ;

expressao_adicao :					expressao_multiplicacao
							| expressao_adicao '+' expressao_multiplicacao
							| expressao_adicao '-'expressao_multiplicacao ;
							

expressao_multiplicacao : 				expressao_cast
							| expressao_multiplicacao '*' expressao_cast
							| expressao_multiplicacao '/' expressao_cast
							| expressao_multiplicacao '%' expressao_cast ;
							

expressao_cast :					expressao_unaria
							| '(' nome_de_tipo ')' expressao_cast ;
							

expressao_unaria :					expressao_posfixo
							| CONSTANTE_INCREMENTO  expressao_unaria
							| operador_unario  expressao_cast
							| SIZEOF   expressao_unaria
							| SIZEOF '(' nome_de_tipo ')' ;
							

operador_unario : 					'&' | '*' | '+' | '-' | '~' | '!' ;			
							

expressao_posfixo : 					expressao_primaria 				
							| expressao_posfixo '[' expressao ']'
							| expressao_posfixo '(' lista_expressao_argumento ')'
							| expressao_posfixo '(' ')'
							| expressao_posfixo '.' ID
							| expressao_posfixo CONSTANTE_PONTEIRO  ID
							| expressao_posfixo CONSTANTE_INCREMENTO ;

							
expressao_primaria :					ID 													
							| constantes 												
							| STRING 												
							| '(' expressao ')' ;
							


lista_expressao_argumento :				expressao_de_atribuicao
							| lista_expressao_argumento ','expressao_de_atribuicao ;
							

constantes :						CONSTANTE_INTEIRO 											
							| CONSTANTE_CARATERE
							| CONSTANTE_FLUTUANTE
							| CONSTANTE_ENUMERADOR ;
							
%%

int main(int argc, char *argv[])
{
    yyparse();
    if(success)
    printf("Parsing da linguagem ocorrido com sucesso\n");
        
        
    
    return 0;
}

int yyerror(const char *msg)
{
	extern int yylineno;
	printf("Parsing falhou. Linguagem nao reconhecida\nLine Number: %d %s\n",yylineno,msg);
	success = 0;
	return 0;
}
							
							
							
								

						
							






							







							


