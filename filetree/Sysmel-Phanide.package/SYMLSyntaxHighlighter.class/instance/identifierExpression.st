accessing
identifierExpression
	^ super identifierExpression ==> [ :token |
		(Keywords includes: token inputValue) ifTrue: [
			self commands add: (PhanideHighlightCommandStyle keyword token: token).
		] ifFalse: [ 
			self commands add: (PhanideHighlightCommandStyle identifier token: token).
		].
		token
	]