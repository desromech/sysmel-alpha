Extension { #name : #Object }

{ #category : #'*Sysmel-Metamodel' }
Object >> asAPSGNodeInEnvironment: anEnvironment at: position [
	^ SYMLAPSGLiteral new
		position: position;
		value: (self asSysmelValueInEnvironment: anEnvironment);
		yourself
]

{ #category : #'*Sysmel-Metamodel' }
Object >> asSysmelValueInEnvironment: anEnvironment [
	^ self sysmelValueWithType: anEnvironment compilationTarget compilerObjectType inEnvironment: anEnvironment
]

{ #category : #'*Sysmel-Metamodel' }
Object >> convertSysmelValueForSequenceEvaluation: value [
	^ value
]

{ #category : #'*Sysmel-Metamodel' }
Object >> createNonInlineLiteralObjectForSysmelObjectModel: objectModel [
	self subclassResponsibility
]

{ #category : #'*Sysmel-Metamodel' }
Object >> isSYMLAPSGNode [
	^ false
]

{ #category : #'*Sysmel-Metamodel' }
Object >> isSysmelClass [
	^ false
]

{ #category : #'*Sysmel-Metamodel' }
Object >> isSysmelGCClass [
	^ false
]

{ #category : #'*Sysmel-Metamodel' }
Object >> isSysmelIncompleteValue [
	^ false
]

{ #category : #'*Sysmel-Metamodel' }
Object >> isSysmelIncompleteValueInEnvironment: anEnvironment [
	^ self isSysmelIncompleteValue
]

{ #category : #'*Sysmel-Metamodel' }
Object >> isSysmelObject [
	^ false
]

{ #category : #'*Sysmel-Metamodel' }
Object >> isSysmelValue [
	^ false
]

{ #category : #'*Sysmel-Metamodel' }
Object >> sysmelEvaluateReference [
	^ self value
]

{ #category : #'*Sysmel-Metamodel' }
Object >> sysmelSetReferenceValue: aValue [
	^ self value: aValue
]

{ #category : #'*Sysmel-Metamodel' }
Object >> sysmelValueWithType: aType inEnvironment: anEnvironment [
	^ SYMLValue new
		value: self;
		type: aType;
		environment: anEnvironment;
		yourself
]

{ #category : #'*Sysmel-Metamodel' }
Object >> unwrapSysmelValue [
	^ self
]
