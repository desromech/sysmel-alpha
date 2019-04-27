Extension { #name : #Symbol }

{ #category : #'*SysmelMoebiusMetamodel-Core' }
Symbol >> asPrettySymbolName [
	^ self
]

{ #category : #'*SysmelMoebiusMetamodel-Core' }
Symbol >> isMbndAnonymousSymbol [
	^ self = #_
]

{ #category : #'*SysmelMoebiusMetamodel-Core' }
Symbol >> mbndLiteralTypeWithTarget: compilationTarget [
	^ compilationTarget literalSymbolType
]
