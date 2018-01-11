.PHONY: test

MOCHA=mocha

all: lunr-mutable.js test

lunr-mutable.js: lib/mutable_builder.js lib/mutable_index.js
	cat preamble $^ postamble > $@

test: lunr-mutable.js
	${MOCHA} test/*.js -u tdd -R dot
