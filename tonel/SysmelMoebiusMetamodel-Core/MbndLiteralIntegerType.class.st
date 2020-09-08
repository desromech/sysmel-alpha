Class {
	#name : #MbndLiteralIntegerType,
	#superclass : #MbndLiteralNumberType,
	#category : #'SysmelMoebiusMetamodel-Core-Type'
}

{ #category : #accessing }
MbndLiteralIntegerType class >> typeName [
	^ #_LiteralInteger
]

{ #category : #initialization }
MbndLiteralIntegerType >> addInstanceMacros [
	self class == MbndLiteralIntegerType ifFalse: [ ^ self ].
	self addLiteralHostDelegationMacrosFor: #(
		// \\
		<< >> & |
		bitXor: bitAnd: bitOr: bitInvert
		lowBit highBit
	).
]

{ #category : #converting }
MbndLiteralIntegerType >> analyzeReinterpretCastNode: node to: targetType with: analyzer [
	node expression isLiteralValueNode ifTrue: [
		targetType isPointerType ifTrue: [
			^ node expression copy
				type: targetType;
				yourself
		].
	].

	^ super analyzeReinterpretCastNode: node to: targetType with: analyzer
]

{ #category : #converting }
MbndLiteralIntegerType >> asCVariadicTypeRequiredAt: position [
	^ self compilationTarget int32Type
]

{ #category : #converting }
MbndLiteralIntegerType >> asDynamicObjectTypeForLiteral [
	^ self compilationTarget managedObjectModel integerClass ifNil: [ super asDynamicObjectTypeForLiteral ]
]

{ #category : #'semantic analysis' }
MbndLiteralIntegerType >> bestConcreteTypeForLiteralValueNode: literalValueNode inScope: scope [
	| literalValue testType |
	literalValue := literalValueNode value.
	literalValue >= 0 ifTrue: [
		literalValue <= 16rFF ifTrue: [ ^ self compilationTarget uint8Type ].
		literalValue <= 16rFFFF ifTrue: [ ^ self compilationTarget uint16Type ].
		literalValue <= 16r7FFFFFFF ifTrue: [ ^ self compilationTarget int32Type ].
		literalValue <= 16rFFFFFFFF ifTrue: [ ^ self compilationTarget uint32Type ].
		literalValue <= 16r7FFFFFFFFFFFFFFF ifTrue: [ ^ self compilationTarget int64Type ].
		literalValue <= 16rFFFFFFFFFFFFFFFF ifTrue: [ ^ self compilationTarget uint64Type ].
		self error: 'Large integers not yet supported.'
	].

	testType := self compilationTarget int8Type.
	(testType isValueInRange: literalValue) ifTrue: [ ^ testType ].
	testType := self compilationTarget int16Type.
	(testType isValueInRange: literalValue) ifTrue: [ ^ testType ].
	testType := self compilationTarget int32Type.
	(testType isValueInRange: literalValue) ifTrue: [ ^ testType ].
	testType := self compilationTarget int64Type.
	(testType isValueInRange: literalValue) ifTrue: [ ^ testType ].
	
	self error: 'Large integers not yet supported.'

]

{ #category : #'testing methods' }
MbndLiteralIntegerType >> isLiteralIntegerType [
	^ true
]

{ #category : #'semantic analysis' }
MbndLiteralIntegerType >> standardConcreteTypeForLiteralValueNode: literalValueNode inScope: scope [
	| literalValue testType |
	literalValue := literalValueNode value.
	
	testType := self compilationTarget int32Type.
	(testType isValueInRange: literalValue) ifTrue: [ ^ testType ].
	testType := self compilationTarget uint32Type.
	(testType isValueInRange: literalValue) ifTrue: [ ^ testType ].
	testType := self compilationTarget int64Type.
	(testType isValueInRange: literalValue) ifTrue: [ ^ testType ].
	testType := self compilationTarget uint64Type.
	(testType isValueInRange: literalValue) ifTrue: [ ^ testType ].
	
	self error: 'Large integers not yet supported.'

]
