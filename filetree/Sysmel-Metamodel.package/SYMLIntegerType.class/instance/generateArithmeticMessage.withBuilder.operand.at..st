arithmetic
generateArithmeticMessage: selector withBuilder: builder operand: operand at: messageNode
	signed ifTrue: [
		SignedIntegerOperationMap at: selector ifPresent: [ :binop |
			^ builder addOperation: binop operand: operand
		]
	] ifFalse: [ 
		UnsignedIntegerOperationMap at: selector ifPresent: [ :binop |
			^ builder addOperation: binop operand: operand
		]
	].
	^ super generateArithmeticMessage: selector withBuilder: builder operand: operand at: messageNode