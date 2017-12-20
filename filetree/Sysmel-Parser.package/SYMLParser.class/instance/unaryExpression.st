accessing
unaryExpression
	^ super unaryExpression ==> [ :list |
		| result |
		result := list first.
		list second do: [ :postfix |
			result := postfix withReceiver: result
		].
		result
	]