%%
%public
%class LexicalAnalyzer
%standalone

%{
  java.util.HashSet<String> identifiers = new java.util.HashSet<>();
%}

LineTerminator = \r|\n|\r\n
EscapeSequence = "\\"["btnrf\'\"\\"]
InputCharacter = [^\\\"\n\r] | {EscapeSequence}
WhiteSpace = {LineTerminator} | [ \t\f]

/* comments */
Comment = {TraditionalComment} | {EndOfLineComment}
TraditionalComment = "/*" [^*] ~"*/" | "/*" "*"+ "/"
EndOfLineComment = "//" {InputCharacter}* {LineTerminator}?

Identifier = [:jletter:] [:jletterdigit:]* // [a-zA-Z]+ [a-zA-Z0-9]*
IntegerLiteral = 0 | [1-9][0-9]*
StringLiteral = \"{InputCharacter}*\"
UnterminatedString = \"{InputCharacter}*

Operator = "+" | "-" | "*" | "/" | "=" | ">" | ">=" | "<" | "<=" | "==" | "++" | "--"
Parenthesis = "(" | ")"
Semicolon = ";"
Keyword = "if" | "then" | "else" | "endif" | "while" | "do" | "endwhile" | "print" | "newline" | "read"

%%

<YYINITIAL> {
  /* keywords *//* operators */
  {Keyword}        { System.out.println("keyword: " + yytext()); }
  {Operator}       { System.out.println("operator: " + yytext()); }
  
  /* parenthesis and semicolon */
  {Parenthesis}    { System.out.println("parenthesis: " + yytext()); }
  {Semicolon}      { System.out.println("semicolon: " + yytext()); }
  
  /* identifiers */
  {Identifier}     {
    if (identifiers.add(yytext())) {
      System.out.println("new identifier: " + yytext());
    } else {
      System.out.println("identifier \"" + yytext() + "\" already in symbol table");
    }
  }

  /* invalid identifiers */
  {IntegerLiteral}{Identifier} {
    System.out.println("Error: invalid identifier: " + yytext());
    System.exit(1);
  }
  
  /* integers *//* strings */
  {IntegerLiteral} { System.out.println("integer: " + yytext()); }
  {StringLiteral}  { System.out.println("string:" + yytext()); }
  
  /* Unterminated strings */
  {UnterminatedString} { 
    System.err.println("Error: Unterminated string: " + yytext());
    System.exit(1);
  }
  
  /* comments *//* whitespace */
  {Comment}        { /* ignore */ }
  {WhiteSpace}     { /* ignore */ }
}

/* error fallback */
[^]                { 
  System.err.println("Error: Unexpected character '" + yytext() + "'");
  System.exit(1);
}