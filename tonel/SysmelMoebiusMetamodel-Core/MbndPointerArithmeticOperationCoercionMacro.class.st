Class {
	#name : #MbndPointerArithmeticOperationCoercionMacro,
	#superclass : #MbndAbstractMacro,
	#category : #'SysmelMoebiusMetamodel-Core-Macro'
}

{ #category : #serialization }
MbndPointerArithmeticOperationCoercionMacro class >> messagePackTypeName [
	^ #MacroPointerArithmeticCoercion
]

{ #category : #'as yet unclassified' }
MbndPointerArithmeticOperationCoercionMacro >> computeAddressSpaceCoercionTypeAt: node left: leftAddressSpace right: rightAddressSpace [
	leftAddressSpace = rightAddressSpace ifTrue: [ ^ leftAddressSpace ].
	self error: 'Cannot compute coercion address space for {1} and {2}' format: { leftAddressSpace printString . rightAddressSpace printString } at: node
	
]

{ #category : #'as yet unclassified' }
MbndPointerArithmeticOperationCoercionMacro >> computeBaseCoercionTypeAt: node left: leftBaseType right: rightBaseType [
	leftBaseType == rightBaseType ifTrue: [ ^ leftBaseType ].
	self halt
]

{ #category : #'as yet unclassified' }
MbndPointerArithmeticOperationCoercionMacro >> computePointerArithmetic: node coercionTypeOf: leftValueType with: rightValueType [
	| addressSpace leftBaseType rightBaseType constantResult baseCoercionType |
	leftValueType == rightValueType ifTrue: [ ^ leftValueType ].
	leftValueType isUndefinedType ifTrue: [ ^ rightValueType withoutReferences ].
	rightValueType isUndefinedType ifTrue: [ ^ leftValueType withoutReferences ].
	
	(leftValueType isConstantType or: [ rightValueType isConstantType ]) ifTrue: [
		^ self computePointerArithmetic: node coercionTypeOf: leftValueType withoutTopDecorations with: rightValueType withoutTopDecorations
	].
	
	(leftValueType isPointerType and: [ rightValueType isPointerType ]) ifTrue: [
		addressSpace := self computeAddressSpaceCoercionTypeAt: node left: leftValueType addressSpace right: rightValueType addressSpace.

		leftBaseType := leftValueType baseType.
		rightBaseType := rightValueType baseType.
		constantResult := leftBaseType isConstantType or: [ rightBaseType isConstantType ].
		
		leftBaseType := leftBaseType withoutDecorations.
		rightBaseType := rightBaseType withoutDecorations.
		
		baseCoercionType := self computeBaseCoercionTypeAt: node left: leftBaseType right: rightBaseType.
		^ (constantResult
			ifTrue: [ baseCoercionType const ]
			ifFalse: [ baseCoercionType ])
			pointerFor: addressSpace
	].
	
	self error: 'Unsupported pointer arithmetic between {1} and {2}.' format: { leftValueType asString . rightValueType asString } at: node
]

{ #category : #serialization }
MbndPointerArithmeticOperationCoercionMacro >> encodeFieldsForMessagePackWith: graphEncoder [
	^ #()
]

{ #category : #'as yet unclassified' }
MbndPointerArithmeticOperationCoercionMacro >> expandMessageNode: node with: analyzer [
	| leftAnalyzedNode rightAnalyzedNode leftValueType rightValueType coercionType leftOperand rightOperand |
	self assert: node receiver isNotNil.
	self assert: node arguments size = 1.

	"Analyze the node."
	leftAnalyzedNode := analyzer analyzeNodeIfNeeded: node receiver.
	rightAnalyzedNode := analyzer analyzeNodeIfNeeded: node arguments first.

	"Get the value types of the nodes."		
	leftValueType := leftAnalyzedNode type bestConcreteTypeForLiteralValueNode: leftAnalyzedNode inScope: analyzer scope.
	rightValueType := rightAnalyzedNode type bestConcreteTypeForLiteralValueNode: rightAnalyzedNode inScope: analyzer scope.
	
	"Compute the coercion type."
	coercionType := self computePointerArithmetic: node coercionTypeOf: leftValueType withoutReferences with: rightValueType withoutReferences.

	"Apply the coercion to the operands."
	leftOperand := analyzer addImplicitCastFor: leftAnalyzedNode to: coercionType.
	rightOperand := analyzer addImplicitCastFor: rightAnalyzedNode to: coercionType.
	
	"Create the expanded message send node, and analyze it"
	^ analyzer visitNode: ((analyzer astBuilder
		send: node selector to: leftOperand withArguments: { rightOperand })
		position: node;
		yourself)
]

{ #category : #serialization }
MbndPointerArithmeticOperationCoercionMacro >> materializeWithGraphDecoder: graphDecoder withFields: encodedFields [
]
