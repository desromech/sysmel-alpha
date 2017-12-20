accessing
commaExpression
	^ super commaExpression ==> [ :list |
		list second ifEmpty: [ list first ] ifNotEmpty: [
			SYMLASTCommaSeparatedList new
				position: list first;
				expressions: {list first} , (list second collect: #second);
				yourself
		]
	]