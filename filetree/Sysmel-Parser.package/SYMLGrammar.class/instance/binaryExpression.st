accessing
binaryExpression
	| binExpr binOpDo prefixOpDo postfixOpDo |
	binExpr := PPExpressionParser new.
	binExpr term: unaryExpression.
	binOpDo := [ :left :operation :right | self operate: left with: right do: operation. ].
	prefixOpDo := [ :operation :operand | self prefix: operation operate: operand ].
	postfixOpDo := [ :operand :operation | self postfix: operation operate: operand ].
	
	binExpr
		group: [ :g |
			"TODO: Is this a good idea?"
			g prefix: (self operatorString: '+') do: prefixOpDo.
			g prefix: (self operatorString: '-') do: prefixOpDo.
			g prefix: (self operatorString: '!') do: prefixOpDo.
			g prefix: (self operatorString: '~') do: prefixOpDo.
			];
		group: [ :g |
			g left: (self operatorString: '*') do: binOpDo. 
			g left: (self operatorString: '/') do: binOpDo. 
			g left: (self operatorString: '%') do: binOpDo.];
		group: [ :g |
			g left: (self operatorString: '+') do: binOpDo.
			g left: (self operatorString: '-') do: binOpDo. ];
		group: [ :g |
			g left: (self operatorString: '<<') do: binOpDo.
			g left: (self operatorString: '>>') do: binOpDo. ];
		group: [ :g |
			g left: (self operatorString: '<=') do: binOpDo.
			g left: (self operatorString: '>=') do: binOpDo.
			g left: (self operatorString: '<') do: binOpDo.
			g left: (self operatorString: '>') do: binOpDo. ];
		group: [ :g |
			g left: (self operatorString: '=') do: binOpDo.
			g left: (self operatorString: '==') do: binOpDo.
			g left: (self operatorString: '~=') do: binOpDo.
			g left: (self operatorString: '~~') do: binOpDo. ];
		group: [ :g |
			g left: (self operatorString: '&') do: binOpDo. ];
		group: [ :g |
			g left: (self operatorString: '^') do: binOpDo. ];
		group: [ :g |
			g left: (self operatorString: '|') do: binOpDo. ];
		group: [ :g |
			g left: (self operatorString: '&&') do: binOpDo. ];
		group: [ :g |
			g left: (self operatorString: '||') do: binOpDo. ];
		group: [ :g |
			g left: (genericBinaryOperator) do: binOpDo. ].
	^ binExpr