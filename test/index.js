/**
 * Test case
 * @author: SimonHao
 * @date:   2015-11-24 16:20:24
 */

'use strict';

var fs     = require('fs');
var parser = require('../lib/parser.js').parser;

var filename = __dirname + '/comm.styl';
var str      = fs.readFileSync(filename, 'utf-8');

var result = parser.parse(str);

console.log(JSON.stringify(result));