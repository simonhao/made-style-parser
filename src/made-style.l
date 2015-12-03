/* lexical scanner from W3C spec. see http://www.w3.org/TR/css3-syntax/#lexical */

single-comment  \/\*[^*]*\*+([^/*][^*]*\*+)*\/
multi-comment   \/\/[^\n\r\f]*
comment         {single-comment}|{multi-comment}

newline         \n|\r\n|\r|\f
space           " "
whitespace      {space}|\t
wss             {whitespace}+
hex-digit       [0-9a-fA-F]
unicode         \\{hex-digit}{1,6}(\r\n|[ \n\r\t\f])?
escape          {unicode}|\\[^\n\r\f0-9a-fA-F]
nonascii        [^\0-\177]
nmstart         [_a-zA-Z]|{nonascii}|{escape}
nmchar          [_a-zA-Z0-9-]|{nonascii}|{escape}
interpolation   \{{nmstart}{nmchar}*\}
ident-part      {interpolation}|{nmchar}
ident           {ident-part}+


integer         [0-9]+
n               "n"
odd             "odd"
even            "even"
sign            "-"|"+"
anb             {odd}|{even}|{sign}?{integer}?{n}{wss}*{sign}{wss}*{integer}|{sign}?{integer}?{n}

hex-color       "#"{hex-digit}{8}|"#"{hex-digit}{6}|"#"{hex-digit}{3}

string          {string1}|{string2}
string1         \"([^\n\r\f\\"]|\\{newline}|{escape})*\"
string2         \'([^\n\r\f\\']|\\{newline}|{escape})*\'
number          [+-]?([0-9]+|[0-9]*\.[0-9]+)("e"[+-]?[0-9]+)?
unicode-range-1 [uU]?\+{hex-digit}{1}[?]{0,5}
unicode-range-2 [uU]?\+{hex-digit}{2}[?]{0,4}
unicode-range-3 [uU]?\+{hex-digit}{3}[?]{0,3}
unicode-range-4 [uU]?\+{hex-digit}{4}[?]{0,2}
unicode-range-5 [uU]?\+{hex-digit}{5}[?]{0,1}
unicode-range-times  {unicode-range-1}|{unicode-range-2}|{unicode-range-3}|{unicode-range-4}|{unicode-range-5}
unicode-range   [uU]?\+{hex-digit}{1,6}|{unicode-range-times}|[uU]?\+{hex-digit}{1,6}\-{hex-digit}{1,6}

%%

{comment}       {return 'COMMENT';}
{whitespace}+   {/* ignore whitespace */}
{newline}       {/* ignore newline */}
"@import"       {return 'IMPORT';}
"@keyframes"    {return 'KEYFRAMES';}
"@media"        {return 'MEDIA';}
":root"         {return 'ROOT';}
"@"{ident}      {return 'AT-KEYWORD';}
{hex-color}     {return 'HEX-COLOR';}
"#"{nmchar}*    {return 'HASH';}
"only"          {return 'ONLY';}
"not"           {return 'NOT';}
"and"           {return 'AND';}
"from"          {return 'FROM';}
"to"            {return 'TO';}
{anb}           {return 'ANB';}
{string}        {return 'STRING';}
{number}"%"     {return 'PERCENTAGE';}
{number}{ident} {return 'DIMENSION';}
{number}        {return 'NUMBER';}
{ident}\(       {return 'FUNCTION';}
{ident}         {return 'IDENT';}
{unicode-range} {return 'UNICODE-RANGE';}
"~="            {return 'INCLUDE-MATCH';}
"|="            {return 'DASH-MATCH';}
"^="            {return 'PREFIX-MATCH';}
"$="            {return 'SUFFIX-MATCH';}
"*="            {return 'SUBSTRING-MATCH';}
"||"            {return 'COLUMN';}
"&"             {return '&';}
":"             {return ':';}
";"             {return ';';}
","             {return ',';}
"["             {return '[';}
"]"             {return ']';}
"("             {return '(';}
")"             {return ')';}
"{"             {return '{';}
"}"             {return '}';}
.               {return yytext;}
<<EOF>>         {return 'EOF';}











