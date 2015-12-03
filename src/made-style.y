%start Stylesheet

%%

Stylesheet
  : Rule-List EOF
    {
      $$ = {
        type: 'stylesheet',
        nodes: $1
      };

      return $$;
    }
  | EOF
    {
      $$ = {
        type: 'stylesheet',
        nodes: []
      };

      return $$;
    }
  ;

Rule-List
  : Qualified-Rule
    {
      $$ = [$1];
    }
  | Rule-List Qualified-Rule
    {
      $$ = $1;
      $$.push($2);
    }
  ;

Qualified-Rule
  : COMMENT
    {
      $$ = {
        type: 'comment',
        val: $1
      };
    }
  | Import-Rule
  | At-Rule
  | Keyframe-Rule
  | Media-Query-Rule
  | Mixin-Rule
  | Variables
  | Declaration -> $1
  | Declaration-Rule -> $1
  ;

Import-Rule
  : IMPORT STRING
    {
      $$ = {
        type: 'import',
        id: $2
      };
    }
  | IMPORT STRING ";"
    {
      $$ = {
        type: 'import',
        id: $2
      };
    }
  ;

At-Rule
  : AT-KEYWORD "{" Rule-List "}"
    {
      $$ = {
        type: 'atrule',
        name: $1,
        nodes: $3
      };
    }
  ;

Keyframe-Rule
  : KEYFRAMES IDENT "{" Keyframe-Block "}"
    {
      $$ = {
        type: 'keyframe',
        name: $2,
        nodes: $4
      };
    }
  ;
Keyframe-Block
  : Keyframe
    {
      $$ = [$1];
    }
  | Keyframe-Block Keyframe
    {
      $$ = $1;
      $$.push($2);
    }
  ;

Keyframe
  : Keyframe-Selector "{" Rule-List "}"
    {
      $$ = {
        type: 'keyframe',
        selector: $1,
        nodes: $3
      };
    }
  ;

Keyframe-Selector
  : FROM -> $1
  | TO -> $1
  | PERCENTAGE -> $1
  ;

Media-Query-Rule
  : MEDIA Media-Query-List "{" Rule-List "}"
    {
      $$ = {
        type: 'media',
        query: $2,
        nodes: $4
      };
    }
  ;

Media-Query-List
  : Media-Query
    {
      $$ = [$1];
    }
  | Media-Query-List "," Media-Query
    {
      $$ = $1;
      $$.push($3);
    }
  ;

Media-Query
  : Query-Parts -> $1
  | Media-Query AND Query-Parts ->$1+ " " + $2 + " " +$3
  ;

Query-Parts
  : Media-Type -> $1
  | "(" IDENT ":" DIMENSION ")" -> $1+$2+$3+$4+$5
  ;

Media-Type
  : IDENT -> $1
  | ONLY IDENT -> $1+$2
  | NOT IDENT -> $1+$2
  ;

Mixin-Rule
  : FUNCTION Param-List ")" "{" Rule-List "}"
    {
      $$ = {
        type: 'mixin',
        name: $1,
        params: $2,
        nodes: $5
      };
    }
  ;

Param-List
  : Param
    {
      $$ = [$1];
    }
  | Param-List "," Param
    {
      $$ = $1;
      $$.push($3);
    }
  ;

Param
  : IDENT -> $1
  | Rest-Args -> $1
  ;

Rest-Args
  : IDENT "." "." "."
    {
      $$ = {
        type: 'reset',
        name: $1
      };
    }
  ;

Variables
  : IDENT "=" Value ";"
    {
      $$ = {
        type: 'variable',
        name: $1,
        val: $3
      };
    }
  ;

Declaration
  : IDENT Value ";"
    {
      $$ = {
        type: 'declaration',
        property: $1,
        val: $2
      };
    }
  ;

Value
  : Expr
    {
      $$ = [$1];
    }
  | Value Expr
    {
      $$ = $1;
      $$.push($2);
    }
  ;

Expr
  : Term -> $1
  | Expr Operator Term -> $1+$2+$3
  ;
Term
  : Computable-Term -> $1
  | Unary-Operator Computable-Term -> $1+$2
  | String-Term -> $1
  ;

Computable-Term
  : NUMBER -> $1
  | DIMENSION -> $1
  | PERCENTAGE -> $1
  | FUNCTION Value ")"
    {
      $$ = {
        type: 'function',
        name: $1,
        params: $2
      };
    }
  ;
Unary-Operator
  : "-" -> $1
  ;
String-Term
  : STRING -> $1
  | IDENT -> $1
  | UNICODERANGE -> $1
  | HEX-COLOR -> $1
  ;

Operator
  : "/" -> $1
  | "," -> $1
  ;

Declaration-Rule
  : Selector-List "{" Rule-List "}"
    {
      $$ = {
        type: 'declaration-rule',
        selector: $1,
        nodes: $3
      };
    }
  ;

Selector-List
  : Selector
    {
      $$ = [$1];
    }
  | Selector-List "," Selector
    {
      $$ = $1;
      $$.push($3);
    }
  ;

Selector
  : Compound-Selector -> $1
  | Complex-Selector -> $1
  ;

Simple-Selector
  : Universal-Selector -> $1
  | Type-Selector -> $1
  | Parent-Selector -> $1
  | Root-Selector -> $1
  | NoStart-Selector -> $1
  ;
NoStart-Selector
  : Attribute-Selector -> $1
  | Class-Selector -> $1
  | ID-Selector -> $1
  | Pseudo-Selector -> $1
  ;

Universal-Selector
  : "*" -> $1
  ;

Type-Selector
  : IDENT -> $1
  ;

Parent-Selector
  : "&" -> $1
  ;

Root-Selector
  : ROOT
    {
      $$ = {
        type: 'root',
        selector:[]
      };
    }
  | ROOT "(" ")"
    {
      $$ = {
        type: 'root',
        selector:[]
      };
    }
  | ROOT "(" Selector-List ")"
    {
      $$ = {
        type: 'root',
        selector: $3
      };
    }
  ;

Attribute-Selector
  : "[" Attribute-Name "]" -> $1+$2+$3
  | "[" Attribute-Name Attribute-Match Attribute-Value "]" -> $1+$2+$3+$4+$5
  ;

Attribute-Name
  : IDENT -> $1
  ;

Attribute-Match
  : "=" -> $1
  | INCLUDE-MATCH -> $1
  | DASH-MATCH -> $1
  | PREFIX-MATCH -> $1
  | SUFFIX-MATCH -> $1
  | SUBSTRING-MATCH -> $1
  ;

Attribute-Value
  : IDENT -> $1
  | STRING -> $1
  ;

Class-Selector
  : "." IDENT -> $1+$2
  ;

ID-Selector
  : HASH -> $1
  ;

Pseudo-Selector
  : ":" IDENT -> $1+$2
  | ":" ":" IDENT -> $1+$2+$3
  | ":" FUNCTION Pseudo-Value ")" -> $1+$2+$3+$4
  ;
Pseudo-Value
  : NUMBER -> $1
  | ANB -> $1
  | IDENT -> $1
  ;

Compound-Selector
  : Simple-Selector -> $1
  | Compound-Selector NoStart-Selector -> $1+$2
  ;

Complex-Selector
  : Compound-Selector Combinator Compound-Selector -> $1+$2+$3
  | Complex-Selector Combinator Compound-Selector -> $1+$2+$3
  ;

Combinator
  : ">" -> $1
  | "+" -> $1
  | "~" -> $1
  ;