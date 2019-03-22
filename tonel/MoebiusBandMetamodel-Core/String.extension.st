Extension { #name : #String }

{ #category : #'*MoebiusBandMetamodel-Core' }
String >> mbndLiteralTypeWithTarget: compilationTarget [
	^ compilationTarget literalStringType
]
