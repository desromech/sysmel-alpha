Extension { #name : #Object }

{ #category : #'*SysmelMoebiusMetamodel-Core' }
Object >> asMoebiusLiteralValueNodeWithTarget: compilationTarget [
	^ MbndAstLiteralValueNode new
		value: self;
		type: (self mbndLiteralTypeWithTarget: compilationTarget);
		yourself
]

{ #category : #'*SysmelMoebiusMetamodel-Core' }
Object >> isMbndAnonymousSymbol [
	^ false
]

{ #category : #'*SysmelMoebiusMetamodel-Core' }
Object >> isMbndAstNode [
	^ false
]

{ #category : #'*SysmelMoebiusMetamodel-Core' }
Object >> isMbndGeneratedSymbol [
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
	^ compilationTarget compilerObjectType
]

{ #category : #'*SysmelMoebiusMetamodel-Core' }
Object >> unwrapMbndValue [
	^ self
]
