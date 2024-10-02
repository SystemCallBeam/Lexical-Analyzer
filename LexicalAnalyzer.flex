%%
%public
%class LexicalAnalyzer
%standalone

%{
  java.util.HashSet<String> identifiers = new java.util.HashSet<>();
%}

LineTerminator = \r|\n|\r\n
InputCharacter = [^\r\n]
WhiteSpace = {LineTerminator} | [ \t\f]

/* comments */
Comment = {TraditionalComment} | {EndOfLineComment}
TraditionalComment = "/*" [^*] ~"*/" | "/*" "*"+ "/"
EndOfLineComment = "//" {InputCharacter}* {LineTerminator}?

Identifier = [:jletter:] [:jletterdigit:]*
IntegerLiteral = 0 | [1-9][0-9]*
StringLiteral = \"[^\"]*\"

Operator = "+" | "-" | "*" | "/" | "=" | ">" | ">=" | "<" | "<=" | "==" | "++" | "--"
Parenthesis = "(" | ")"
Semicolon = ";"
Keyword = "if" | "then" | "else" | "endif" | "while" | "do" | "endwhile" | "print" | "newline" | "read"

%%

<YYINITIAL> {
  /* keywords */
  {Keyword}        { System.out.println("keyword: " + yytext()); }
  
  /* operators */
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
  
  /* integers */
  {IntegerLiteral} { System.out.println("integer: " + yytext()); }
  
  /* strings */
  {StringLiteral}  { System.out.println("string:" + yytext()); }
  
  /* comments */
  {Comment}        { /* ignore */ }

  /* whitespace */
  {WhiteSpace}     { /* ignore */ }
}

/* error fallback */
[^]                { 
  System.err.println("Error: Unexpected character '" + yytext() + "'");
  System.exit(1);
}