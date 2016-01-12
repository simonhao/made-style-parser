/* lexical scanner from W3C spec. see http://www.w3.org/TR/css3-syntax/#lexical */

%x STATE-COLONS

multi-comment   \/\*[^*]*\*+([^/*][^*]*\*+)*\/
single-comment  \/\/[^\n\r\f]*

newline         \n|\r\n|\r|\f
space           " "
whitespace      {space}|\t
ws              {whitespace}*
wss             {whitespace}+
hex-digit       [0-9a-fA-F]
unicode         \\{hex-digit}{1,6}(\r\n|[ \n\r\t\f])?
escape          {unicode}|\\[^\n\r\f0-9a-fA-F]
nonascii        [^\0-\177]
nmstart         [_a-zA-Z-]|{nonascii}|{escape}
nmchar          [_a-zA-Z0-9-]|{nonascii}|{escape}
ident           {nmstart}{nmchar}*

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
unicode-range-1 [uU]\+{hex-digit}{1}\?{1,5}
unicode-range-2 [uU]\+{hex-digit}{2}\?{1,4}
unicode-range-3 [uU]\+{hex-digit}{3}\?{1,3}
unicode-range-4 [uU]\+{hex-digit}{4}\?{1,2}
unicode-range-5 [uU]\+{hex-digit}{5}\?{1}
unicode-range-times  {unicode-range-1}|{unicode-range-2}|{unicode-range-3}|{unicode-range-4}|{unicode-range-5}
unicode-range   {unicode-range-times}|[uU]\+{hex-digit}{1,6}\-{hex-digit}{1,6}|[uU]\+{hex-digit}{1,6}

%%

{single-comment}
  %{
    yytext = yytext.substring(2);
    return 'COMMENT';
  %}
{multi-comment}
  %{
    yytext = yytext.substring(2, (yytext.length - 2));
    return 'COMMENT';
  %}
{ws}{newline}{ws}
  %{
    /* ignore newline */
  %}
"@import"
  %{
    return 'IMPORT';
  %}
"@require"
  %{
    return 'REQUIRE';
  %}
"@keyframes"
  %{
    return 'KEYFRAMES';
  %}
"@media"
  %{
    return 'MEDIA';
  %}
":root"
  %{
    return 'ROOT';
  %}
"@"{ident}
  %{
    return 'AT-KEYWORD';
  %}
{hex-color}
  %{
    return 'COLOR';
  %}
"#"{nmchar}*
  %{
    return 'HASH';
  %}
{ident}\({ws}
  %{
    yytext = yytext.trim().substring(0, (yytext.length - 1));
    return 'FUNCTION';
  %}
"only"
  %{
    return 'ONLY';
  %}
"not"
  %{
    return 'NOT';
  %}
"and"
  %{
    return 'AND';
  %}
"from"
  %{
    return 'FROM';
  %}
"to"
  %{
    return 'TO';
  %}
{anb}
  %{
    return 'ANB';
  %}
{string}
  %{
    yytext = yytext.substring(1, (yytext.length - 1));
    return 'STRING';
  %}
{number}"%"
  %{
    return 'PERCENTAGE';
  %}
{number}{ident}
  %{
    return 'DIMENSION';
  %}
{number}
  %{
    return 'NUMBER';
  %}
{unicode-range}
  %{
    return 'UNICODE-RANGE';
  %}
{ident}
  %{
    return 'IDENT';
  %}
{ws}"+"{ws}
  %{
    yytext = yytext.trim();
    return '+';
  %}
{ws}"="{ws}
  %{
    yytext = yytext.trim();
    return '=';
  %}
{ws}">"{ws}
  %{
    yytext = yytext.trim();
    return '>';
  %}
{ws}"<"{ws}
  %{
    yytext = yytext.trim();
    return '<';
  %}
{ws}">="{ws}
  %{
    yytext = yytext.trim();
    return '>=';
  %}
{ws}"<="{ws}
  %{
    yytext = yytext.trim();
    return '<=';
  %}
{ws}"~="{ws}
  %{
    yytext = yytext.trim();
    return '~=';
  %}
{ws}"|="{ws}
  %{
    yytext = yytext.trim();
    return '|=';
  %}
{ws}"^="{ws}
  %{
    yytext = yytext.trim();
    return '^=';
  %}
{ws}"$="{ws}
  %{
    yytext = yytext.trim();
    return "$=";
  %}
{ws}"*="{ws}
  %{
    yytext = yytext.trim();
    return '*=';
  %}
{ws}"||"{ws}
  %{
    yytext = yytext.trim();
    return '||';
  %}
"&"             %{ return yytext; %}
{ws}":"
  %{
    this.begin('STATE-COLONS');
  %}

<STATE-COLONS>":"
  %{
    this.popState();
    return 'PSEUDO-ELEMENT';
  %}
<STATE-COLONS>{wss}
  %{
    this.popState();
    return ':';
  %}
<STATE-COLONS>[^;{()]*")"
  %{
    this.popState();
    this.unput(yytext);

    return ':';
  %}
<STATE-COLONS>[^;{()]*";"
  %{
    this.popState();
    this.unput(yytext);

    return ':';
  %}
<STATE-COLONS>[^;{()]*"{"
  %{
    this.popState();
    this.unput(yytext);

    return 'PSEUDO-CLASS';
  %}
<STATE-COLONS>.
  %{
    this.popState();
    this.unput(yytext);

    return 'PSEUDO-CLASS';
  %}

{ws}";"{ws}
  %{
    yytext = yytext.trim();
    return ';';
  %}
{ws}","{ws}
  %{
    yytext = yytext.trim();
    return ',';
  %}
{ws}"["{ws}
  %{
    yytext = yytext.trim();
    return '[';
  %}
{ws}"]"{ws}
  %{
    yytext = yytext.trim();
    return ']';
  %}
"("{ws}
  %{
    yytext = yytext.trim();
    return '(';
  %}
{ws}")"
  %{
    yytext = yytext.trim();
    return ')';
  %}
{ws}"{"{ws}
  %{
    yytext = yytext.trim();
    return '{';
  %}
{ws}"}"{ws}
  %{
    yytext = yytext.trim();
    return '}';
  %}
{wss}
  %{
    return 'WSS';
  %}
.               %{ return yytext; %}
<<EOF>>         %{ return 'EOF'; %}
