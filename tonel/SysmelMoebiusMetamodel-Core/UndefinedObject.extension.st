Extension { #name : #UndefinedObject }

{ #category : #'*SysmelMoebiusMetamodel-Core' }
UndefinedObject >> asPrettySymbolName [
	^ #_
]

{ #category : #'*SysmelMoebiusMetamodel-Core' }
UndefinedObject >> isMbndAnonymousSymbol [
	^ true
]

{ #category : #'*SysmelMoebiusMetamodel-Core' }
UndefinedObject >> mbndLiteralTypeWithTarget: compilationTarget [
	^ compilationTarget undefinedType
]
