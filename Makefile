all: build

build:
	node ./node_modules/jison/lib/cli.js src/made-style.y src/made-style.l
	mv made-style.js lib/parser.js