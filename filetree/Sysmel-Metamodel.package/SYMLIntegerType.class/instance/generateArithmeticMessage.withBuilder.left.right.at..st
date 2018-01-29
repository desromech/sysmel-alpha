arithmetic
generateArithmeticMessage: selector withBuilder: builder left: left right: right at: messageNode
	signed ifTrue: [
		SignedIntegerOperationMap at: selector ifPresent: [ :binop |
			^ builder addOperation: binop left: left right: right
		]
	] ifFalse: [ 
		UnsignedIntegerOperationMap at: selector ifPresent: [ :binop |
			^ builder addOperation: binop left: left right: right
		]
	].
	^ super generateArithmeticMessage: selector withBuilder: builder left: left right: right at: messageNode