Class {
	#name : #MbndLiteralBooleanType,
	#superclass : #MbndLiteralValueType,
	#category : #'SysmelMoebiusMetamodel-Core-Type'
}

{ #category : #accessing }
MbndLiteralBooleanType class >> typeName [
	^ #_LiteralBoolean
]

{ #category : #converting }
MbndLiteralBooleanType >> asCVariadicTypeRequiredAt: position [
	^ self compilationTarget booleanType
]

{ #category : #'semantic analysis' }
MbndLiteralBooleanType >> bestConcreteTypeForLiteralValueNode: literalValueNode inScope: scope [
	^ self compilationTarget booleanType
]

{ #category : #initialization }
MbndLiteralBooleanType >> initializeNonTraitType [
	super initializeNonTraitType.
	self
		onMacroSelectors: #(and: &&) do: [ :node :builder |
			(builder if: node receiver trueValue: node arguments first falseValue: builder literalBooleanFalse)
				position: node;
				yourself
		];
		onMacroSelectors: #(or: ||) do: [ :node :builder |
			(builder if: node receiver trueValue: builder literalBooleanTrue falseValue: node arguments first)
				position: node;
				yourself
		];
		addLiteralHostDelegationMacrosFor: #(not).
]

{ #category : #'testing methods' }
MbndLiteralBooleanType >> isLiteralBooleanType [
	^ true
]
