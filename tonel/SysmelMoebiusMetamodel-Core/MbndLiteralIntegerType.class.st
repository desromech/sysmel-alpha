Class {
	#name : #MbndLiteralIntegerType,
	#superclass : #MbndLiteralNumberType,
	#category : #'SysmelMoebiusMetamodel-Core-Type'
}

{ #category : #accessing }
MbndLiteralIntegerType class >> typeName [
	^ #_LiteralInteger
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

{ #category : #'semantic analysis' }
MbndLiteralIntegerType >> bestConcreteTypeForLiteralValueNode: literalValueNode inScope: scope [
	self flag: 'TODO: Use the number range for selecting this.'.
	^ self compilationTarget int32Type
]

{ #category : #initialization }
MbndLiteralIntegerType >> initialize [
	super initialize.
	self addLiteralHostDelegationMacrosFor: #(
		// \\
		<< >> & |
		bitXor: bitAnd: bitInvert
	).
]

{ #category : #'testing methods' }
MbndLiteralIntegerType >> isLiteralIntegerType [
	^ true
]
