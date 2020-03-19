Extension { #name : #String }

{ #category : #'*SysmelMoebiusMetamodel-Core' }
String >> asPrettySymbolName [
	^ self
]

{ #category : #'*SysmelMoebiusMetamodel-Core' }
String >> mbndLiteralTypeWithTarget: compilationTarget [
	^ compilationTarget literalStringType
]
