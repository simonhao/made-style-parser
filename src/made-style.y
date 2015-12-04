%start Stylesheet

%%

Stylesheet
  : Rule-List EOF
    {
      $$ = {
        type: 'stylesheet',
        rule: $1
      };

      return $$;
    }
  | EOF
    {
      $$ = {
        type: 'stylesheet'
      };

      return $$;
    }
  ;

Rule-List
  : Qualified-Rule
    {
      $$ = {
        type: 'rule-list',
        nodes: [$1]
      };
    }
  | Rule-List Qualified-Rule
    {
      $$ = $1;
      $$.nodes.push($2);
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
  | Media-Query-Rule -> $1
  | Import-Rule -> $1
  | At-Rule -> $1
  | Keyframes-Rule -> $1
  | Mixin-Rule -> $1
  | Variables-Rule -> $1
  | Root-Rule -> $1
  | Declaration-Rule -> $1
  | Declaration-Set-Rule -> $1
  ;

Rule-Block
  : "{" "}" -> null
  | "{" Rule-List "}" -> $2
  ;

Media-Query-Rule
  : MEDIA Query-List Rule-Block
    {
      $$ = {
        type: 'media',
        query: $2,
        rule: $3
      };
    }
  ;

Query-List
  : Query -> [$1]
  | Query-List "," Query
    {
      $$ = $1;
      $$.push($3);
    }
  ;

Query
  : Query-Parts -> $1
  | Query Query-Condition Query-Parts -> $1+ " " + $2+ " " + $3
  ;

Query-Parts
  : Media-Type -> $1
  | Media-Feature -> $1
  ;

Media-Type
  : IDENT -> $1
  ;

Media-Feature
  : "(" Feature-Name ")" -> $1+$2+$3
  | "(" Feature-Name ":" Feature-Value ")" -> $1+$2+$3+$4+$5
  | "(" Feature-Range ")" -> $1+$2+$3
  ;

Feature-Name
  : IDENT -> $1
  ;

Feature-Value
  : IDENT -> $1
  | Computable-Feature-Value -> $1
  ;

Computable-Feature-Value
  : Computable-Term -> $1
  | Computable-Feature-Value "/" Computable-Term ->$1+$2+$3
  ;

Feature-Range
  : Feature-Name Range-Term Computable-Feature-Value -> $1+$2+$3
  | Feature-Value-Range-List -> $1
  ;

Feature-Value-Range-List
  : Feature-Value-Less-List -> $1
  | Feature-Value-Great-List -> $1
  | Feature-Value-Equal-List -> $1
  ;
Feature-Value-Less-List
  : Computable-Feature-Value Range-Less Feature-Name -> $1+$2+$3
  | Feature-Value-Less-List Range-Less Computable-Feature-Value -> $1+$2+$3
  ;

Feature-Value-Great-List
  : Computable-Feature-Value Range-Great Feature-Name -> $1+$2+$3
  | Feature-Value-Great-List Range-Great Computable-Feature-Value -> $1+$2+$3
  ;

Feature-Value-Equal-List
  : Computable-Feature-Value Range-Equal Feature-Name -> $1+$2+$3
  ;

Range-Term
  : Range-Equal -> $1
  | Range-Less -> $1
  | Range-Great -> $1
  ;

Range-Equal
  : "=" -> $1
  ;

Range-Less
  : "<" -> $1
  | "<" "=" -> $1+$2
  ;

Range-Great
  : ">" -> $1
  | ">" "=" -> $1+$2
  ;

Query-Condition
  : AND -> $1
  | ONLY -> $1
  | NOT -> $1
  | OR -> $1
  ;

Import-Rule
  : IMPORT STRING ";"
    {
      $$ = {
        type: 'import',
        id: $2
      };
    }
  ;

At-Rule
  : AT-KEYWORD Rule-Block
    {
      $$ = {
        type: 'at-rule',
        rule: $2
      };
    }
  ;

Keyframes-Rule
  : KEYFRAMES IDENT Keyframes-Block
    {
      $$ = {
        type: 'keyframes',
        name: $2,
        rule: $3
      };
    }
  ;

Keyframes-Block
  : "{" "}" -> null
  | "{" Keyframe-List "}" -> $2
  ;

Keyframe-List
  : Keyframe
    {
      $$ = {
        type: 'keyframe-list',
        nodes: [$1]
      };
    }
  | Keyframe-List Keyframe
    {
      $$ = $1;
      $$.nodes.push($2);
    }
  ;

Keyframe
  : Keyframe-Selector Declaration-Block
    {
      $$ = {
        type: 'keyframe',
        selector: $1,
        rule: $2
      };
    }
  ;

Keyframe-Selector
  : FROM -> $1
  | TO -> $1
  | PERCENTAGE -> $1
  ;

Declaration-Block
  : "{" "}" -> null
  | "{" Declaration-Set "}" -> $2
  ;

Declaration-Set
  : Declaration-Rule
    {
      $$ = {
        type: 'declaration-set',
        nodes: [$1]
      };
    }
  | Declaration-Set Declaration-Rule
    {
      $$ = $1;
      $$.nodes.push($2);
    }
  ;

Mixin-Rule
  : FUNCTION Param-List ")" Rule-Block
    {
      $$ = {
        type: 'mixin',
        name: $1,
        param: $2,
        rule: $4
      };
    }
  ;

Param-List
  : Param -> [$1]
  | Param-List "," Param
    {
      $$ = $1;
      $$.push($3);
    }
  ;

Param
  : IDENT -> $1
  | Reset-Param -> $1
  ;

Reset-Param
  : IDENT "." "." "."
    {
      $$ = {
        type: 'reset-param',
        name: $1
      };
    }
  ;

Variables-Rule
  : IDENT "=" Value ";"
    {
      $$ = {
        type: 'variable',
        name: $1,
        val: $3
      };
    }
  ;

Root-Rule
  : ROOT Rule-Block
    {
      $$ = {
        type: 'root',
        rule: $2
      };
    }
  ;

Declaration-Rule
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
      $$ = {
        type: 'value',
        expr: [$1]
      };
    }
  | Value Expr
    {
      $$ = $1;
      $$.expr.push($2);
    }
  ;

Expr
  : Term
    {
      $$ = {
        type: 'expr',
        term: [$1]
      };
    }
  | Expr Operator Term
    {
      $$ = $1;
      $$.term.push($2);
      $$.term.push($3);
    }
  ;

Operator
  : "/" -> $1
  | "," -> $1
  ;

Term
  : Computable-Term -> $1
  | Unary-Operator Computable-Term -> $1+$2
  | String-Term -> $1
  | Function-Term -> $1
  ;

Computable-Term
  : NUMBER -> $1
  | DIMENSION -> $1
  | PERCENTAGE -> $1
  ;

Unary-Operator
  : "-" -> $1
  ;

String-Term
  : IDENT
    {
      $$ = {
        type: 'ident',
        name: $1
      };
    }
  | STRING -> $1
  ;

Function-Term
  : FUNCTION Value ")"
    {
      $$ = {
        type: 'function',
        name: $1,
        args: $2
      };
    }
  ;

Declaration-Set-Rule
  : Selector-List Rule-Block
    {
      $$ = {
        type: 'declaration-set',
        selector: $1,
        rule: $2
      };
    }
  ;

Selector-List
  : Complex-Selector
    {
      $$ = {
        type: 'selector-list',
        nodes: [$1]
      };
    }
  | Selector-List "," Complex-Selector
    {
      $$ = $1;
      $$.nodes.push($3);
    }
  ;

Complex-Selector
  : Compound-Selector
    {
      $$ = {
        type: 'selector',
        nodes: [$1]
      };
    }
  | Complex-Selector Combinator Compound-Selector
    {
      $$ = $1;
      $$.nodes.push($2);
      $$.nodes.push($3);
    }
  ;

Compound-Selector
  : Simple-Selector -> [$1]
  | Compound-Selector NonStart-Selector
    {
      $$ = $1;
      $$.push($2);
    }
  ;

Combinator
  : ">" -> $1
  | "~" -> $1
  | "+" -> $1
  | COLUMN -> $1
  | "/" IDENT "/" -> $1
  ;

Simple-Selector
  : Type-Selector -> $1
  | Parent-Selector -> $1
  | Universal-Selector -> $1
  | NonStart-Selector -> $1
  ;

NonStart-Selector
  : Class-Selector -> $1
  | ID-Selector -> $1
  | Attrib-Selector -> $1
  | Pseudo-Selector -> $1
  ;

Type-Selector
  : IDENT -> $1
  ;

Parent-Selector
  : "&"
    {
      $$ = {
        type: 'parent-selector'
      };
    }
  ;

Universal-Selector
  : "*" -> $1
  ;

Class-Selector
  : "." IDENT -> $1+$2
  ;

ID-Selector
  : HASH -> $1
  ;

Attrib-Selector
  : "[" Attrib-Name "]"  -> $1+$2+$3
  | "[" Attrib-Name Attrib-Match Attrib-Value "]"  -> $1+$2+$3+$4+$5
  ;

Attrib-Name
  : IDENT -> $1
  ;

Attrib-Match
  : "=" -> $1
  | INCLUDE-MATCH -> $1
  | DASH-MATCH -> $1
  | PREFIX-MATCH -> $1
  | SUFFIX-MATCH -> $1
  | SUBSTRING-MATCH -> $1
  ;

Attrib-Value
  : IDENT -> $1
  | STRING -> $1
  ;

Pseudo-Selector
  : ":" IDENT -> $1+$2
  | ":" Function-Pseudo -> $1+$2
  | ":" ":" IDENT -> $1+$2+$3
  | ":" ":" Function-Pseudo -> $1+$2+$3
  ;

Function-Pseudo
  : FUNCTION ")" -> $1+$2
  | FUNCTION Pseudo-Value ")" -> $1+$2+$3
  ;

Pseudo-Value
  : ANB -> $1
  | Value -> $1
  ;


