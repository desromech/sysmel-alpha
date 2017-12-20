accessing
implicitContextChainExpression
	^ super implicitContextChainExpression ==> [ :list |
		list second ifEmpty: [
			list first
		] ifNotEmpty: [
			| position chained |
			position := list second first first.
			chained := list second collect: #second.

			SYMLASTMessageChain new
				position: position;
				messages: { list first } , chained;
				yourself
		]
	]