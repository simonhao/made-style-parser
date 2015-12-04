%start Stylesheet

%%

Stylesheet
  : Rule-List EOF
  | EOF
  ;

Rule-List
  : Qualified-Rule
  | Rule-List Qualified-Rule
  ;

Qualified-Rule
  : COMMENT
  | Media-Query-Rule
  | Import-Rule
  | At-Rule
  | Keyframes-Rule
  | Mixin-Rule
  | Variables-Rule
  | Root-Rule
  | Declaration-Rule
  | Declaration-Set-Rule
  ;

Rule-Block
  : "{" "}"
  | "{" Rule-List "}"
  ;

Media-Query-Rule
  : MEDIA Query-List Rule-Block
  ;

Query-List
  : Query
  | Query-List "," Query
  ;

Query
  : Query-Parts
  | Query Query-Condition Query-Parts
  ;

Query-Parts
  : Media-Type
  | Media-Feature
  ;

Media-Type
  : IDENT
  ;

Media-Feature
  : "(" Feature-Name ")"
  | "(" Feature-Name ":" Feature-Value ")"
  | "(" Feature-Range ")"
  ;

Feature-Name
  : IDENT
  ;

Feature-Value
  : IDENT
  | Computable-Feature-Value
  ;

Computable-Feature-Value
  : Computable-Term
  | Computable-Feature-Value "/" Computable-Term
  ;

Feature-Range
  : Feature-Name Range-Term Computable-Feature-Value
  | Feature-Value-Range-List
  ;

Feature-Value-Range-List
  : Feature-Value-Less-List
  | Feature-Value-Great-List
  | Feature-Value-Equal-List
  ;
Feature-Value-Less-List
  : Computable-Feature-Value Range-Less Feature-Name
  | Feature-Value-Less-List Range-Less Computable-Feature-Value
  ;

Feature-Value-Great-List
  : Computable-Feature-Value Range-Great Feature-Name
  | Feature-Value-Great-List Range-Great Computable-Feature-Value
  ;

Feature-Value-Equal-List
  : Computable-Feature-Value Range-Equal Feature-Name
  ;

Range-Term
  : Range-Equal
  | Range-Less
  | Range-Great
  ;

Range-Equal
  : "="
  ;

Range-Less
  : "<"
  | "<" "="
  ;

Range-Great
  : ">"
  | ">" "="
  ;

Query-Condition
  : AND
  | ONLY
  | NOT
  | OR
  ;

Import-Rule
  : IMPORT STRING ";"
  ;

At-Rule
  : AT-KEYWORD Rule-Block
  ;

Keyframes-Rule
  : KEYFRAMES IDENT Keyframes-Block
  ;

Keyframes-Block
  : "{" "}"
  | "{" Keyframe-List "}"
  ;

Keyframe-List
  : Keyframe
  | Keyframe-List Keyframe
  ;

Keyframe
  : Keyframe-Selector Declaration-Block
  ;

Keyframe-Selector
  : FROM
  | TO
  | PERCENTAGE
  ;

Declaration-Block
  : "{" "}"
  | "{" Declaration-Set "}"
  ;

Declaration-Set
  : Declaration-Rule
  | Declaration-Set Declaration-Rule
  ;

Mixin-Rule
  : FUNCTION Param-List ")" Rule-Block
  ;

Param-List
  : Param
  | Param-List "," Param
  ;

Param
  : IDENT
  | Reset-Param
  ;

Reset-Param
  : IDENT "." "." "."
  ;


Variables-Rule
  : IDENT "=" Value ";"
  ;

Root-Rule
  : ROOT Rule-Block
  ;

Declaration-Rule
  : IDENT Value ";"
  ;

Value
  : Expr
  | Value Expr
  ;

Expr
  : Term
  | Expr Operator Term
  ;

Operator
  : "/"
  | ","
  ;

Term
  : Computable-Term
  | Unary-Operator Computable-Term
  | String-Term
  | Function-Term
  ;

Computable-Term
  : NUMBER
  | DIMENSION
  | PERCENTAGE
  ;

Unary-Operator
  : "-"
  ;

String-Term
  : IDENT
  | STRING
  ;

Function-Term
  : FUNCTION Value ")"
  ;

Declaration-Set-Rule
  : Selector-List Rule-Block
  ;

Selector-List
  : Complex-Selector
  | Selector-List "," Complex-Selector
  ;

Complex-Selector
  : Compound-Selector
  | Complex-Selector Combinator Compound-Selector
  ;

Compound-Selector
  : Simple-Selector
  | Compound-Selector NonStart-Selector
  ;

Combinator
  : ">"
  | "~"
  | "+"
  | COLUMN
  | "/" IDENT "/"
  ;

Simple-Selector
  : Type-Selector
  | Parent-Selector
  | Universal-Selector
  | NonStart-Selector
  ;

NonStart-Selector
  : Class-Selector
  | ID-Selector
  | Attrib-Selector
  | Pseudo-Selector
  ;

Type-Selector
  : IDENT
  ;

Parent-Selector
  : "&"
  ;

Universal-Selector
  : "*"
  ;

Class-Selector
  : "." IDENT
  ;

ID-Selector
  : HASH
  ;

Attrib-Selector
  : "[" Attrib-Name "]"
  | "[" Attrib-Name Attrib-Match Attrib-Value "]"
  ;

Attrib-Name
  : IDENT
  ;

Attrib-Match
  : "="
  | INCLUDE-MATCH
  | DASH-MATCH
  | PREFIX-MATCH
  | SUFFIX-MATCH
  | SUBSTRING-MATCH
  ;

Attrib-Value
  : IDENT
  | STRING
  ;

Pseudo-Selector
  : ":" IDENT
  | ":" Function-Pseudo
  | ":" ":" IDENT
  | ":" ":" Function-Pseudo
  ;

Function-Pseudo
  : FUNCTION ")"
  | FUNCTION Pseudo-Value ")"
  ;

Pseudo-Value
  : ANB
  | Value
  ;


