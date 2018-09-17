Class {
	#name : #SYMLValue,
	#superclass : #SYMLAbstractConcreteValue,
	#instVars : [
		'value',
		'type',
		'environment'
	],
	#category : #'Sysmel-Metamodel-Values'
}

{ #category : #'instance creation' }
SYMLValue class >> value: aValue type: aType [
	^ self new
		value: aValue;
		type: aType;
		yourself
]

{ #category : #comparing }
SYMLValue >> = other [
	^ self class == other class and:
	[ type == other type and: 
	[ value = other value ] ]
]

{ #category : #'as yet unclassified' }
SYMLValue >> analyzeAPSGIdentifierToMe: identifier inEnvironment: anEnvironment [
	^ self asAPSGNodeInEnvironment: anEnvironment at: identifier position
]

{ #category : #converting }
SYMLValue >> asAPSGNodeValueWithError: errorMessage at: aPosition [
	self type isAPSGNodeType ifTrue: [ ^ self value ].
	self type cleanValueType isAPSGNodeType ifTrue: [
		self type isReferenceType ifTrue: [ 
			^ self value sysmelEvaluateReference
		] ifFalse: [
			"This could be a const"
			^ self value
		]
	].
	
	self error: errorMessage at: aPosition
]

{ #category : #converting }
SYMLValue >> asFunctionActivationValueAt: aPosition [
	self type isMetaObjectType ifTrue: [ 
		^ self value
	].

	^ self type convertValueToFunctionActivationValue: self at: aPosition
]

{ #category : #converting }
SYMLValue >> asSysmelValueInEnvironment: anEnvironment [
	^ self
]

{ #category : #'as yet unclassified' }
SYMLValue >> concretizeInEnvironment: concreteEnvironment [
	^ self
]

{ #category : #accessing }
SYMLValue >> environment [
	^ environment
]

{ #category : #accessing }
SYMLValue >> environment: anObject [
	environment := anObject
]

{ #category : #'meta evaluation' }
SYMLValue >> generateSSACodeWith: aBuilder [
	^ type generateSSAValue: self value withBuilder: aBuilder
]

{ #category : #comparing }
SYMLValue >> hash [
	^ (self class identityHash bitXor: type identityHash) bitXor: value hash
]

{ #category : #testing }
SYMLValue >> isMetaObjectValue [
	^ type isMetaObjectType
]

{ #category : #testing }
SYMLValue >> isSysmelValue [
	^ true
]

{ #category : #printing }
SYMLValue >> printOn: aStream [
	^ aStream nextPutAll: self class name;
		nextPutAll: ' value: (';
		print: self value;
		nextPutAll: ') type: (';
		print: type;
		nextPutAll: ')'
]

{ #category : #'as yet unclassified' }
SYMLValue >> sameValueButWithType: aNewType [
	^ self copy type: aNewType
]

{ #category : #'compile time evaluation' }
SYMLValue >> sysmelPerform: aSelector withArguments: arguments [
	^ self sysmelPerform: aSelector withArguments: arguments fallbackWith: [
		self error: 'Cannot perform sysmel method {1} with receiver of type {2}.' format: { aSelector printString  . self asString }
	]

]

{ #category : #'compile time evaluation' }
SYMLValue >> sysmelPerform: aSelector withArguments: arguments fallbackWith: fallbackBlock [
	| method result |
	(value respondsTo: #sysmelPerform:withArguments:fallbackWith:) ifTrue: [ 
		^ value sysmelPerform: aSelector withArguments: arguments fallbackWith: fallbackBlock
	].

	method := (self type lookupSelector: aSelector).
	method ifNil: [
		^ fallbackBlock value
	].

	result := method evaluateWithReceiver: value arguments: (arguments collect: [ :arg | arg asSysmelValueInEnvironment: environment ]) inEnvironment: self environment at: (SYMLSourcePosition new).
	^ result
]

{ #category : #'as yet unclassified' }
SYMLValue >> sysmelValueWithType: aType inEnvironment: anEnvironment [
	^ type coerceValue: self into: aType at: nil
]

{ #category : #accessing }
SYMLValue >> type [
	^ type
]

{ #category : #accessing }
SYMLValue >> type: anObject [
	type := anObject
]

{ #category : #'as yet unclassified' }
SYMLValue >> unwrapSysmelValue [
	^ self value unwrapSysmelValue
]

{ #category : #accessing }
SYMLValue >> value [
	^ value
]

{ #category : #accessing }
SYMLValue >> value: anObject [
	value := anObject
]
