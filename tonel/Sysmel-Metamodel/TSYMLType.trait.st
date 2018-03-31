Trait {
	#name : #TSYMLType,
	#category : #Sysmel-Metamodel-Types
}

{ #category : #coercion }
TSYMLType >> arithmeticCoerceWith: other [
	self == other ifTrue: [ ^ self ].
	^ nil
]

{ #category : #coercion }
TSYMLType >> arithmeticCoerceWith: other at: aSourcePosition [
	| result |
	result := self arithmeticCoerceWith: other.
	result ifNil: [ self error: 'Failed to perform arithmetic coercion with type {1} and {2}.' format: { self asString . other asString } at: aSourcePosition ].
	^ result
]

{ #category : #converting }
TSYMLType >> asSysmelValueInEnvironment: anEnvironment [
	^ self sysmelValueWithType: self metaType inEnvironment: anEnvironment
]

{ #category : #coercion }
TSYMLType >> canBeNode: node coercedImplicitlyInto: targetType at: aSourcePosition [
	self == targetType ifTrue: [ ^ true ].
	^ false
]

{ #category : #coercion }
TSYMLType >> canBeNode: node coercedImplicitlyIntoCVariadicAt: aSourcePosition [
	^ false
]

{ #category : #'meta evaluation' }
TSYMLType >> cleanType [
	^ self
]

{ #category : #coercion }
TSYMLType >> coerceImplicitlyValue: aValue at: aSourcePosition [
	^ aValue type value: aValue coercedImplicitlyInto: self at: aSourcePosition
]

{ #category : #coercion }
TSYMLType >> coercedImplicitlyInto: targetType at: aSourcePosition [
	self coercedImplicitlyNode: nil into: targetType at: aSourcePosition
]

{ #category : #coercion }
TSYMLType >> coercedImplicitlyNode: node into: targetType at: aSourcePosition [
	(self canBeNode: node coercedImplicitlyInto: targetType at: aSourcePosition) ifTrue: [ ^ self ].
	
	self error: 'Cannot coerce implicitly a value of type {1} into {2}' format: {self asString . targetType asString} at: aSourcePosition
]

{ #category : #coercion }
TSYMLType >> coercedImplicitlyNode: node intoCVariadicAt: aSourcePosition [
	(self canBeNode: node coercedImplicitlyIntoCVariadicAt: aSourcePosition) ifTrue: [ ^ self ].
	
	self error: 'Cannot coerce implicitly a value of type {1} into C variadic argument' format: {self asString} at: aSourcePosition
]

{ #category : #accessing }
TSYMLType >> compilationTarget [
	^ self target
]

{ #category : #accessing }
TSYMLType >> concreteSSAType [
	^ self ssaType
]

{ #category : #'meta evaluation' }
TSYMLType >> concreteTypeForNode: aNode [
	^ self
]

{ #category : #decorators }
TSYMLType >> const [
	<compileTime>
	^ self compilationTarget constOfType: self
]

{ #category : #'meta evaluation' }
TSYMLType >> evaluateReferenceAt: position [
	^ self sysmelValueWithType: self metaType inEnvironment: nil
]

{ #category : #'meta evaluation' }
TSYMLType >> evaluateTypeAt: position [
	^ self metaType
]

{ #category : #'meta evaluation' }
TSYMLType >> evaluateValue: aValue inEnvironment: anEnvironment [
	^ aValue
]

{ #category : #'meta evaluation' }
TSYMLType >> evaluateValueType: aValue inEnvironment: anEnvironment [
	^ aValue type
]

{ #category : #'meta evaluation' }
TSYMLType >> evaluateValueWithoutReferences: aValue inEnvironment: evaluationEnvironment [
	^ self evaluateValue: aValue inEnvironment: evaluationEnvironment
]

{ #category : #'meta methods' }
TSYMLType >> findMetaMethodForSelector: aSelector inImageReceiver: aReceiver accessor: aReceiverAccessor at: aSourcePosition [
	| compiledMethod actualReceiver |
	actualReceiver := aReceiver.
	aReceiverAccessor ifNotNil: [
		actualReceiver := actualReceiver perform: aReceiverAccessor
	].

	compiledMethod := actualReceiver class lookupSelector: aSelector.
	compiledMethod ifNil: [ ^ nil ].
	
	"Ensure this contains"
	(compiledMethod hasPragmaNamed: #compileTime) ifFalse: [ ^ nil ].
	
	^ (compiledMethod hasPragmaNamed: #lazy) ifTrue: [
		SYMLLazyMessageSendMetaMethod new
			compilationTarget: self compilationTarget;
			receiverAccessor: aReceiverAccessor;
			rewrite: (compiledMethod hasPragmaNamed: #rewrite);
			yourself
	] ifFalse: [ 
		SYMLNormalMessageSendMetaMethod new
			compilationTarget: self compilationTarget;
			receiverAccessor: aReceiverAccessor;
			rewrite: (compiledMethod hasPragmaNamed: #rewrite);
			yourself
	]
]

{ #category : #'meta methods' }
TSYMLType >> findMetaMethodForSelector: aSelector inImageReceiver: aReceiver at: aSourcePosition [
	^ self findMetaMethodForSelector: aSelector inImageReceiver: aReceiver accessor: nil at: aSourcePosition
]

{ #category : #arithmetic }
TSYMLType >> generateArithmeticMessage: selector withBuilder: builder left: left right: right at: messageNode [
	self error: 'Unsupported arithmetic binary operation {1} for values of type {2} ' format: { selector . self asString } at: messageNode
]

{ #category : #arithmetic }
TSYMLType >> generateArithmeticMessage: selector withBuilder: builder operand: operand at: messageNode [
	self error: 'Unsupported arithmetic unary operation {1} for values of type {2} ' format: { selector . self asString } at: messageNode
]

{ #category : #'meta evaluation' }
TSYMLType >> generateSSAValue: value withBuilder: aBuilder [
	self explicitRequirement
]

{ #category : #testing }
TSYMLType >> isAPSGNode [
	^ false
]

{ #category : #testing }
TSYMLType >> isASTNode [
	^ false
]

{ #category : #testing }
TSYMLType >> isBooleanType [
	^ false
]

{ #category : #testing }
TSYMLType >> isCompilerObjectType [
	^ false
]

{ #category : #testing }
TSYMLType >> isConstantType [
	^ false
]

{ #category : #testing }
TSYMLType >> isDecoratorType [
	^ false
]

{ #category : #testing }
TSYMLType >> isFloatType [
	^ false
]

{ #category : #testing }
TSYMLType >> isFunctionGroupType [
	^ false
]

{ #category : #testing }
TSYMLType >> isFunctionType [
	^ false
]

{ #category : #testing }
TSYMLType >> isIntegerType [
	^ false
]

{ #category : #testing }
TSYMLType >> isLiteralType [
	^ false
]

{ #category : #testing }
TSYMLType >> isMetaType [
	^ false
]

{ #category : #testing }
TSYMLType >> isNumberType [
	^ false
]

{ #category : #testing }
TSYMLType >> isPointerType [
	^ false
]

{ #category : #testing }
TSYMLType >> isReferenceType [
	^ false
]

{ #category : #testing }
TSYMLType >> isScalarType [
	^ false
]

{ #category : #testing }
TSYMLType >> isTupleType [
	^ false
]

{ #category : #testing }
TSYMLType >> isVoidType [
	^ false
]

{ #category : #testing }
TSYMLType >> isVolatileType [
	^ false
]

{ #category : #'meta methods' }
TSYMLType >> metaMethodForMessage: messageNode inEnvironment: anEnvironment at: aSourcePosition [
	^ nil
]

{ #category : #accessing }
TSYMLType >> metaType [
	^ self target metaTypeFor: self
]

{ #category : #decorators }
TSYMLType >> pointer [
	<compileTime>
	^ self compilationTarget pointerTo: self
]

{ #category : #decorators }
TSYMLType >> ref [
	<compileTime>
	^ self compilationTarget referenceTo: self
]

{ #category : #arithmetic }
TSYMLType >> resultTypeForArithmeticMessage: selector at: node [
	self error: 'Unsupported arithmetic operator {1} for values of type {2} ' format: { selector . self asString } at: node
]

{ #category : #coercion }
TSYMLType >> ssaCoerceImplicitly: value to: targetType with: builder at: aSourcePosition [
	self == targetType ifTrue: [ ^ value ].
	self cleanType == targetType ifTrue: [ ^ value ]. "const -> non-const copy"
	
	self error: 'Unimplemented coercion from {1} to {2}.' format: { self asString . targetType asString } at: aSourcePosition
]

{ #category : #coercion }
TSYMLType >> ssaCoerceImplicitly: value toCVariadicWith: builder at: aSourcePosition [
	self error: 'Unimplemented coercion from {1} to C variadic argument.' format: { self asString } at: aSourcePosition
]

{ #category : #accessing }
TSYMLType >> ssaType [
	self explicitRequirement
]

{ #category : #accessing }
TSYMLType >> target [
	^ self explicitRequirement
]

{ #category : #coercion }
TSYMLType >> value: aValue coercedImplicitlyInto: targetType at: aSourcePosition [
	targetType == self ifTrue: [ ^ aValue ].
	self error: 'Cannot coerce value of type {1} into type {2}' format: { self asString . targetType } at: aSourcePosition
]

{ #category : #'meta evaluation' }
TSYMLType >> valueType [
	^ self
]
