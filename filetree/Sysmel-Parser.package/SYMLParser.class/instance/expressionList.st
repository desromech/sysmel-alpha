accessing
expressionList
	^ super expressionList ==> [ :list |
		({ list first } , (list second collect: #second)) select: #isNotNil
	]