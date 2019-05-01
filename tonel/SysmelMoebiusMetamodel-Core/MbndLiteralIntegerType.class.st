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
