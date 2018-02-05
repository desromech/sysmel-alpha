arithmetic
generateArithmeticMessage: selector withBuilder: builder operand: operand at: messageNode
	self assert: selector == #not.
	^ builder lnot: operand