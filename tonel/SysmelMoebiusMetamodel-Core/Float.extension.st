Extension { #name : #Float }

{ #category : #'*SysmelMoebiusMetamodel-Core' }
Float >> mbndLiteralTypeWithTarget: compilationTarget [
	^ compilationTarget literalFloatType
]

{ #category : #'*SysmelMoebiusMetamodel-Core' }
Float class >> qNaN [
	^ self fromIEEE64Bit: "Fill the exponent" ((1<<11) - 1 << 52) | "non zero fractional part" (1 << 51)
]

{ #category : #'*SysmelMoebiusMetamodel-Core' }
Float class >> sNaN [
	^ self fromIEEE64Bit: "Fill the exponent" ((1<<11) - 1 << 52) | "non zero fractional part" (1 << 50)
]
