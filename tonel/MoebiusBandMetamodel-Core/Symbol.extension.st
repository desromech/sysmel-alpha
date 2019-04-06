Extension { #name : #Symbol }

{ #category : #'*MoebiusBandMetamodel-Core' }
Symbol >> asPrettySymbolName [
	^ self
]

{ #category : #'*MoebiusBandMetamodel-Core' }
Symbol >> mbndLiteralTypeWithTarget: compilationTarget [
	^ compilationTarget literalSymbolType
]
