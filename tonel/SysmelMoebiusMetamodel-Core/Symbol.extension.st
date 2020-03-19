Extension { #name : #Symbol }

{ #category : #'*SysmelMoebiusMetamodel-Core' }
Symbol >> isMbndAnonymousSymbol [
	^ self = #_
]

{ #category : #'*SysmelMoebiusMetamodel-Core' }
Symbol >> mbndLiteralTypeWithTarget: compilationTarget [
	^ compilationTarget literalSymbolType
]
