Extension { #name : #Object }

{ #category : #'*SysmelMoebiusMetamodel-Core' }
Object >> asMoebiusLiteralValueNodeWithTarget: compilationTarget [
	^ MbndAstLiteralValueNode new
		value: self;
		type: (self mbndLiteralTypeWithTarget: compilationTarget);
		yourself
]

{ #category : #'*SysmelMoebiusMetamodel-Core' }
Object >> asMoebiusValueWithTarget: compilationTarget [
	^ self asMoebiusValueWithType: (self mbndLiteralTypeWithTarget: compilationTarget)
]

{ #category : #'*SysmelMoebiusMetamodel-Core' }
Object >> asMoebiusValueWithType: aType [
	^ MbndValue value: self type: aType
	
]

{ #category : #'*SysmelMoebiusMetamodel-Core' }
Object >> isMbndAbstractValue [
	^ false
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
Object >> isMbndGenerateSymbolRemovedFromDebug [
	^ self isMbndAnonymousSymbol
]

{ #category : #'*SysmelMoebiusMetamodel-Core' }
Object >> isMbndGeneratedSymbol [
	^ false
]

{ #category : #'*SysmelMoebiusMetamodel-Core' }
Object >> isMbndProgramEntity [
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
Object >> isMbndVTablePointerValue [
	^ false
]

{ #category : #'*SysmelMoebiusMetamodel-Core' }
Object >> isSysmelObjectFileTarget [
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
