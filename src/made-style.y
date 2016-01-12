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
  : Qualified-Rule -> [$1]
  | Rule-List Qualified-Rule
    %{
      $$ = $1;
      $$.push($2);
    %}
  ;

Qualified-Rule
  : Comment -> $1
  | Media-Query-Rule -> $1
  | Import-Rule -> $1
  | At-Rule -> $1
  | Keyframes-Rule -> $1
  | Mixin-Rule -> $1
  | Root-Rule -> $1
  | Declaration-Rule -> $1
  | Declaration-Set-Rule -> $1
  ;

Ident
  : IDENT
    %{
      $$ = {
        type: 'ident',
        val: $1
      };
    %}
  ;

Number
  : NUMBER
    %{
      $$ = {
        type: 'literal',
        val: $1
      };
    %}
  ;

Dimension
  : DIMENSION
    %{
      $$ = {
        type: 'literal',
        val: $1
      };
    %}
  ;

Unicode-Range
  : UNICODE-RANGE
    %{
      $$ = {
        type: 'literal',
        val: $1
      };
    %}
  ;

Percentage
  : PERCENTAGE
    %{
      $$ = {
        type: 'literal',
        val: $1
      };
    %}
  ;

String
  : STRING
    %{
      $$ = {
        type: 'string',
        val: $1
      };
    %}
  ;

Color
  : COLOR
    %{
      $$ = {
        type: 'literal',
        val: $1
      };
    %}
  ;

Anb
  : ANB
    %{
      $$ = {
        type: 'literal',
        val: $1
      };
    %}
  ;

Function
  : FUNCTION ")"
    %{
      $$ = {
        type: 'function',
        name: $1,
        params: []
      };
    %}
  | FUNCTION Function-Params ")"
    %{
      $$ = {
        type: 'function',
        name: $1,
        params: $2
      }
    %}
  ;

Function-Params
  : Function-Param -> [$1]
  | Function-Params "," Function-Param
    %{
      $$ = $1;
      $$.push($3);
    %}
  ;

Function-Param
  : Ident -> $1
  | Number -> $1
  | Dimension -> $1
  | Unicode-Range -> $1
  | Percentage -> $1
  | String
  | Color
  | Function -> $1
  ;

Rule-Block
  : "{" "}" -> null
  | "{" Rule-List "}" -> $2
  ;


Comment
  : COMMENT
    %{
      $$ = {
        type: 'comment',
        val: $1
      };
    %}
  ;

Import-Rule
  : IMPORT WSS STRING ";"
    %{
      $$ = {
        type: 'import',
        once: true,
        id: $3
      };
    %}
  | REQUIRE WSS STRING ";"
    %{
      $$ = {
        type: 'import',
        id: $3
      };
    %}
  ;

Declaration-Rule
  : IDENT ":" Property-List ";"
    %{
      $$ = {
        type: 'declaration',
        name: $1,
        list: $3
      };
    %}
  ;

Property-List
  : Property-Item
    %{
      $$ = [$1];
    %}
  | Property-List WSS Property-Item
    %{
      $$ = $1;
      $$.push($3);
    %}
  ;

Property-Item
  : Property
    %{
      $$ = {
        type: 'property_item',
        item: [$1]
      };
    %}
  | Property-Item Property-Operator Property
    %{
      $$ = $1;
      $$.item.push($2);
      $$.item.push($3);
    %}
  ;

Property
  : Ident -> $1
  | Number -> $1
  | Dimension -> $1
  | Unicode-Range -> $1
  | Percentage -> $1
  | String
  | Color
  | Function -> $1
  ;

Property-Operator
  : "/"
    %{
      $$ = {
        type: 'literal',
        val: $1
      };
    %}
  | ","
    %{
      $$ = {
        type: 'literal',
        val: $1
      };
    %}
  ;



Mixin-Rule
  : FUNCTION ")" Rule-Block
    %{
      $$ = {
        type: 'mixin',
        name: $1,
        params: [],
        nodes: $4
      };
    %}
  | FUNCTION Mix-Params ")" Rule-Block
    %{
      $$ = {
        type: 'mixin',
        name: $1,
        params: $2,
        nodes: $4
      };
    %}
  ;

Mix-Params
  : Mix-Param -> [$1]
  | Mix-Params "," Mix-Param
    %{
      $$ = $1;
      $$.push($3);
    %}
  ;

Mix-Param
  : Ident -> $1
  | Rest-Param -> $1
  ;

Rest-Param
  : IDENT "." "." "."
    %{
      $$ = {
        type: 'reset',
        name: $1
      };
    %}
  ;

Root
  : ROOT
    %{
      $$ = {
        type: 'literal',
        val: $1
      };
    %}
  ;

Root-Rule
  : Root Rule-Block
    %{
      $$ = {
        type: 'root',
        nodes: $2
      };
    %}
  ;

Declaration-Set-Rule
  : Selector-List Rule-Block
    %{
      $$ = {
        type: 'declaration_set',
        selector: $1,
        nodes: $2
      };
    %}
  ;

Selector-List
  : Complex-Selector -> [$1]
  | Selector-List "," Complex-Selector
    %{
      $$ = $1;
      $$.push($3);
    %}
  ;

Complex-Selector
  : Compound-Selector
    %{
      $$ = {
        type: 'complex_selector',
        list: [$1]
      };
    %}
  | Complex-Selector Combinator Compound-Selector
    %{
      $$ = $1;
      $$.list.push($2);
      $$.list.push($3);
    %}
  ;

Combinator
  : ">"
    %{
      $$ = {
        type: 'literal',
        val: $1
      };
    %}
  | "~"
    %{
      $$ = {
        type: 'literal',
        val: $1
      };
    %}
  | "+"
    %{
      $$ = {
        type: 'literal',
        val: $1
      };
    %}
  | WSS
    %{
      $$ = {
        type: 'literal',
        val: $1
      };
    %}
  ;

Compound-Selector
  : Simple-Selector
    %{
      $$ = {
        type: 'compound_selector',
        list: [$1]
      };
    %}
  | Compound-Selector Simple-Selector
    %{
      $$ = $1;
      $$.list.push($2);
    %}
  ;

Simple-Selector
  : Type-Selector -> $1
  | Parent-Selector -> $1
  | Universal-Selector -> $1
  | Class-Selector -> $1
  | ID-Selector -> $1
  | Attrib-Selector -> $1
  | Pseudo-Selector -> $1
  ;

Type-Selector
  : IDENT
    %{
      $$ = {
        type: 'type_selector',
        val: $1
      };
    %}
  ;

Parent-Selector
  : "&"
    %{
      $$ = {
        type: 'parent_selector',
        val: $1
      };
    %}
  ;

Universal-Selector
  : "*"
    %{
      $$ = {
        type: 'universal_selector',
        val: $1
      };
    %}
  ;

Class-Selector
  : "." IDENT
    %{
      $$ = {
        type: 'class_selector',
        val: $2
      };
    %}
  ;

ID-Selector
  : HASH
    %{
      $$ = {
        type: 'id_selector',
        val: $1
      };
    %}
  ;

Attrib-Selector
  : "[" IDENT "]"
    %{
      $$ = {
        type: 'attrib_selector',
        name: $2
      };
    %}
  | "[" IDENT "=" Ident "]"
    %{
      $$ = {
        type: 'attrib_selector',
        name: $2,
        val: $4
      };
    %}
  | "[" IDENT "=" String "]"
    %{
      $$ = {
        type: 'attrib_selector',
        name: $2,
        val: $4
      };
    %}
  ;

Pseudo-Selector
  : PSEUDO-CLASS IDENT
    %{
      $$ = {
        type: 'pseudo_class_selector',
        name: $2
      };
    %}
  | PSEUDO-ELEMENT IDENT
    %{
      $$ = {
        type: 'pseudo_element_selector',
        name: $2
      };
    %}
  | PSEUDO-CLASS Function-Pseudo
    %{
      $$ = {
        type: 'pseudo_class_selector',
        func: $2
      };
    %}
  | PSEUDO-ELEMENT Function-Pseudo
    %{
      $$ = {
        type: 'pseudo_element_selector',
        func: $2
      };
    %}
  ;

Function-Pseudo
  : FUNCTION ")"
    %{
      $$ = {
        type: 'function_pseudo',
        name: $1
      };
    %}
  | FUNCTION Pseudo-Value ")"
    %{
      $$ = {
        type: 'function_pseudo',
        name: $1,
        val: $2
      };
    %}
  ;

Pseudo-Value
  : Complex-Selector -> $1
  | Root -> $1
  | Number -> $1
  | Dimension -> $1
  | Unicode-Range -> $1
  | Percentage -> $1
  | String -> $1
  | Color -> $1
  | Anb -> $1
  ;

Media-Query-Rule
  : MEDIA WSS Media-Query-List Rule-Block
    %{
      $$ = {
        type: 'media',
        query: $3,
        rule: $4
      };
    %}
  ;

Media-Query-List
  : Media-Query -> [$1]
  | Media-Query-List "," Media-Query
    %{
      $$ = $1;
      $$.push($3);
    %}
  ;

Media-Query
  : Media-Condition
    %{
      $$ = {
        type: 'media_query',
        val: [$1]
      };
    %}
  | Media-Type
    %{
      $$ = {
        type: 'media_query',
        val: [$1]
      };
    %}
  | NOT WSS Media-Type
    %{
      $$ = {
        type: 'media_query',
        val: [{type:'not', val:$1},$3]
      };
    %}
  | ONLY WSS Media-Type
    %{
      $$ = {
        type: 'media_query',
        val: [{type:'only', val:$1},$3]
      };
    %}
  | Media-Query WSS AND WSS Media-Condition
    %{
      $$ = $1;
      $$.val.push({type:'and', val:$3});
      $$.val.push($5);
    %}
  ;

Media-Type
  : IDENT
    %{
      $$ = {
        type: 'media_type',
        val: $1
      };
    %}
  ;

Media-Condition
  : "(" IDENT ")"
    %{
      $$ = {
        type: 'media_condition',
        name: $2
      }
    %}
  | "(" IDENT ":" Property-Item ")"
    %{
      $$ = {
        type: 'media_condition',
        name: $2,
        val: $4
      };
    %}
  | "(" IDENT Media-Operator Media-Condition-Value ")"
    %{
      $$ = {
        type: 'media_condition_range',
        val: [{type:'literal', val:$2}, $3, $4]
      };
    %}
  | "(" Media-Condition-Value Media-Operator IDENT Media-Operator Media-Condition-Value ")"
    %{
      $$ = {
        type: 'media_condition_range',
        val: [$2,$3,{type:'literal', val:$4}, $5, $6]
      };
    %}
  ;

Media-Condition-Value
  : Media-Condition-Item
    %{
      $$ = {
        type: 'property_item',
        item: [$1]
      };
    %}
  | Media-Condition-Value Property-Operator Media-Condition-Item
    %{
      $$ = $1;
      $$.item.push($2);
      $$.item.push($3);
    %}
  ;

Media-Condition-Item
  : Number -> $1
  | Dimension -> $1
  | Percentage -> $1
  | String -> $1
  | Color -> $1
  | Function -> $1
  ;

Media-Operator
  : "="
    %{
      $$ = {
        type: 'literal',
        val: $1
      };
    %}
  | ">"
    %{
      $$ = {
        type: 'literal',
        val: $1
      };
    %}
  | "<"
    %{
      $$ = {
        type: 'literal',
        val: $1
      };
    %}
  | ">="
    %{
      $$ = {
        type: 'literal',
        val: $1
      };
    %}
  | "<="
    %{
      $$ = {
        type: 'literal',
        val: $1
      };
    %}
  ;


Keyframes-Rule
  : KEYFRAMES WSS IDENT Keyframes-Block
    %{
      $$ = {
        type: 'keyframes',
        name: $3,
        rule: $4
      };
    %}
  ;

Keyframes-Block
  : "{" "}" -> null
  | "{" Keyframes-List "}" -> $2
  ;

Keyframes-List
  : Keyframes -> [$1]
  | Keyframes-List Keyframes
    %{
      $$ = $1;
      $$.push($2);
    %}
  ;

Keyframes
  : Keyframes-Selector "{" Keyframes-Set "}"
    %{
      $$ = {
        type: 'keyframe',
        selector: $1,
        rule: $3
      };
    %}
  ;

Keyframes-Selector
  : FROM -> $1
  | TO -> $1
  | PERCENTAGE -> $1
  ;

Keyframes-Set
  : Declaration-Rule -> [$1]
  | Keyframes-Set Declaration-Rule
    %{
      $$ = $1;
      $$.push($2);
    %}
  ;

At-Rule
  : AT-KEYWORD Rule-Block
    %{
      $$ = {
        type: 'at_rule',
        name: $1,
        rule: $2
      };
    %}
  ;