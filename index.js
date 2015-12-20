/**
 * Made-Style-Parser
 * @author: SimonHao
 * @date:   2015-12-20 17:10:21
 */

'use strict';

var Parser   = require('./lib/parser.js').Parser;
var Lexer    = require('./lib/parser.js').parser.lexer;
var inherits = require('util').inherits;

function StyleLexer(filename){
  this.filename = filename;
}

StyleLexer.prototype = Object.create(Lexer);

StyleLexer.prototype.parseError = function(msg, info){
  console.error('lexer error from file "', this.filename, '"');
  console.error(msg);

  throw new Error('Lexer Error');
};


function StyleParser(str, filename){
  this.str = str;
  this.filename = filename;

  this.lexer = new StyleLexer(filename);

  Parser.call(this);
}

inherits(StyleParser, Parser);

StyleParser.prototype.parse = function(){
  return Parser.prototype.parse.call(this, this.str);
};

StyleParser.prototype.parseError = function(msg, info){
  console.error('Parse error from file "', this.filename, '"');
  console.error(msg);

  throw new Error('Parse Error');
};

module.exports = StyleParser;