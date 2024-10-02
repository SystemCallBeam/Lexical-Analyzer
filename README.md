# JFlex Lexical Analyzer
### ส่วนที่ 1: การกำหนดค่าเริ่มต้น
```flex
%%
%public
%class LexicalAnalyzer
%standalone
```
- %% เป็นสัญลักษณ์ที่ใช้แบ่งส่วนต่างๆ ของไฟล์ JFlex
-  %public กำหนดให้คลาสที่สร้างขึ้นเป็น public
-  %class LexicalAnalyzer กำหนดชื่อคลาสที่จะถูกสร้างเป็น LexicalAnalyzer
-  %standalone สร้างเมธอด main() โดยอัตโนมัติ ทำให้สามารถรันโปรแกรมได้โดยตรง

### ส่วนที่ 2: โค้ด Java ที่จะถูกรวมเข้าไปในคลาส
```flex
%{
  java.util.HashSet<String> identifiers = new java.util.HashSet<>();
%}
```

- สร้าง HashSet ชื่อ identifiers เพื่อเก็บ identifier ที่พบในโค้ด ใช้เป็น symbol table อย่างง่าย

### ส่วนที่ 3: การกำหนด Regular Expressions

```flex
LineTerminator = \r|\n|\r\n
InputCharacter = [^\r\n]
WhiteSpace = {LineTerminator} | [ \t\f]
```
- LineTerminator คือตัวขึ้นบรรทัดใหม่ (CR, LF, หรือ CRLF)
- InputCharacter คือตัวอักษรใดๆ ยกเว้นตัวขึ้นบรรทัดใหม่
- WhiteSpace คือช่องว่าง, tab, form feed, หรือตัวขึ้นบรรทัดใหม่

```flex
Comment = {TraditionalComment} | {EndOfLineComment}
TraditionalComment = "/*" [^*] ~"*/" | "/*" "*"+ "/"
EndOfLineComment = "//" {InputCharacter}* {LineTerminator}?
```
- กำหนด pattern สำหรับ comment แบบหลายบรรทัด (/* */) และแบบบรรทัดเดียว (//)

```flex
Identifier = [:jletter:] [:jletterdigit:]*
IntegerLiteral = 0 | [1-9][0-9]*
StringLiteral = \"[^\"]*\"
```
- Identifier เริ่มด้วยตัวอักษรและตามด้วยตัวอักษรหรือตัวเลข
- IntegerLiteral คือเลข 0 หรือเลขที่ไม่ขึ้นต้นด้วย 0
- StringLiteral คือข้อความในเครื่องหมายคำพูด

```flex
Operator = "+" | "-" | "*" | "/" | "=" | ">" | ">=" | "<" | "<=" | "==" | "++" | "--"
Parenthesis = "(" | ")"
Semicolon = ";"
Keyword = "if" | "then" | "else" | "endif" | "while" | "do" | "endwhile" | "print" | "newline" | "read"
```
- กำหนด pattern สำหรับ operators, วงเล็บ, เครื่องหมายอัฒภาค, และ keywords
### ส่วนที่ 4: กฎการจับคู่และการกระทำ
```flex
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
```
- <YYINITIAL> คือสถานะเริ่มต้นของ lexer
- แต่ละกฎจะจับคู่ token ที่ตรงกับ pattern ที่กำหนดไว้
- เมื่อพบ token ที่ตรงกับ pattern จะทำการพิมพ์ประเภทของ token และค่าของมัน
- สำหรับ identifier มีการตรวจสอบว่าเป็น identifier ใหม่หรือมีอยู่แล้วใน symbol table
- Comment และ whitespace จะถูกละเว้น (ignore)
### ส่วนที่ 5: การจัดการข้อผิดพลาด
```flex
/* error fallback */
[^]                { 
  System.err.println("Error: Unexpected character '" + yytext() + "'");
  System.exit(1);
}
```
- หากพบตัวอักษรที่ไม่ตรงกับ pattern ใดๆ ข้างต้น จะถือว่าเป็นข้อผิดพลาด
- โปรแกรมจะแสดงข้อความแจ้งเตือนและหยุดการทำงานทันที

โค้ดนี้สร้าง lexical analyzer อย่างง่ายที่สามารถแยกแยะ token ประเภทต่างๆ ในภาษาโปรแกรมมิ่งได้ เช่น keywords, operators, identifiers, literals และ comments โดยใช้ JFlex ซึ่งเป็นเครื่องมือสำหรับสร้าง lexical analyzer จาก regular expressions