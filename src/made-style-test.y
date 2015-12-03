%start Stylesheet

%%

Stylesheet
  : Token-List EOF
  | EOF
  ;

Token-List
  : Token
  | Token-List Token
  ;

Property
  : PROPERTY Value-List NEWLINE
  ;
Value-List
  : Value
  | Value-List Value
  ;
Value
  : IDENT
  | FUNCTION
  ;

Type-Selector
  : IDENT
  ;

Token
  : Property
    {
      console.log("Property:[" + $1 + "]");
    }
  | Type-Selector
    {
      console.log("Type-Selector:[" + $1 + "]");
    }
  | COMMENT
    {
      console.log("COMMENT:[" + $1 + "]");
    }
  | IMPORT
    {
      console.log("IMPORT:[" + $1 + "]");
    }
  | MEDIA
    {
      console.log("MEDIA:[" + $1 + "]");
    }
  | KEYFRAMES
    {
      console.log("KEYFRAMES:[" + $1 + "]");
    }
  | AT-KEYWORD
    {
      console.log("AT-KEYWORD:[" + $1 + "]");
    }
  | STRING
    {
      console.log("STRING:[" + $1 + "]");
    }
  | DIMENSION
    {
      console.log("DIMENSION:[" + $1 + "]");
    }
  | AND
    {
      console.log("AND:[" + $1 + "]");
    }
  | FROM
    {
      console.log("FROM:[" + $1 + "]");
    }
  | TO
    {
      console.log("TO:[" + $1 + "]");
    }
  | HASH
    {
      console.log("HASH:[" + $1 + "]");
    }
  | "{"
    {
      console.log($1);
    }
  | "}"
    {
      console.log($1);
    }
  | "("
    {
      console.log($1);
    }
  | ")"
    {
      console.log($1);
    }
  | ":"
    {
      console.log($1);
    }
  | ";"
    {
      console.log($1);
    }
  | "["
    {
      console.log($1);
    }
  | "]"
    {
      console.log($1);
    }
  | "="
    {
      console.log($1);
    }
  | WHITESPACE
  | "."
    {
      console.log($1);
    }
  | ","
    {
      console.log($1);
    }
  | "&"
    {
      console.log($1);
    }
  | PERCENTAGE
    {
      console.log($1);
    }
  | FUNCTION
    {
      console.log($1);
    }
  | NEWLINE
    {
      console.log('NEWLINE:');
    }
  ;