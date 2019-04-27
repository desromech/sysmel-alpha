Extension { #name : #Object }

{ #category : #'*SysmelMoebiusMetamodel-Core' }
Object >> isMbndAnonymousSymbol [
	^ false
]

{ #category : #'*SysmelMoebiusMetamodel-Core' }
Object >> isMbndAstNode [
	^ false
]

{ #category : #'*SysmelMoebiusMetamodel-Core' }
Object >> isMbndSymbolBinding [
	^ false
]

{ #category : #'*SysmelMoebiusMetamodel-Core' }
Object >> isMbndType [
	^ false
]

{ #category : #'*SysmelMoebiusMetamodel-Core' }
Object >> mbndLiteralTypeWithTarget: compilationTarget [
	self subclassResponsibility
]

{ #category : #'*SysmelMoebiusMetamodel-Core' }
Object >> unwrapMbndValue [
	^ self
]
