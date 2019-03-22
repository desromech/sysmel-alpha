Extension { #name : #Integer }

{ #category : #'*MoebiusBandMetamodel-Core' }
Integer >> mbndLiteralTypeWithTarget: compilationTarget [
	^ compilationTarget literalIntegerType
]
