Class {
	#name : #MbndArithmeticOperationCoercionMacro,
	#superclass : #MbndAbstractMacro,
	#category : #'SysmelMoebiusMetamodel-Core-Macro'
}

{ #category : #serialization }
MbndArithmeticOperationCoercionMacro class >> messagePackTypeName [
	^ #MacroArithmeticOperationCoercion
]

{ #category : #serialization }
MbndArithmeticOperationCoercionMacro >> encodeFieldsForMessagePackWith: graphEncoder [
	^ #()
]

{ #category : #'as yet unclassified' }
MbndArithmeticOperationCoercionMacro >> ensureLiteralNode: literalNode hasConcreteType: literalConcreteType [
	literalNode isLiteralValueNode ifFalse: [ ^ literalNode ].
	literalNode type = literalConcreteType ifTrue: [ ^ literalNode ].
	^ literalNode copy type: literalConcreteType
]

{ #category : #'as yet unclassified' }
MbndArithmeticOperationCoercionMacro >> ensureLiteralNode: literalNode hasConcreteType: literalConcreteType coercedTo: coercionType [
	| result |
	result := self ensureLiteralNode: literalNode hasConcreteType: literalConcreteType.
	literalNode isLiteralValueNode ifTrue: [
		literalConcreteType isPrimitiveIntegerType ifTrue: [ 
			coercionType isPrimitiveIntegerType ifTrue: [ ^ literalNode copy type: coercionType ].
		].
	].

	^ result
]

{ #category : #'as yet unclassified' }
MbndArithmeticOperationCoercionMacro >> expandMessageNode: node with: analyzer [
	| leftAnalyzedNode rightAnalyzedNode leftValueType rightValueType coercionType leftOperand rightOperand |
	self assert: node receiver isNotNil.
	self assert: node arguments size = 1.

	"Analyze the node."
	leftAnalyzedNode := analyzer analyzeNodeIfNeeded: node receiver.
	rightAnalyzedNode := analyzer analyzeNodeIfNeeded: node arguments first.

	"Get the value types of the nodes."		
	leftValueType := leftAnalyzedNode type withoutReferences withoutDecorations.
	rightValueType := rightAnalyzedNode type withoutReferences withoutDecorations.
	
	"Vector - Matrix multiplication is a special case."
	(node selector value = #* and: [ leftValueType isPrimitiveVectorType and: [ rightValueType isPrimitiveMatrixType ] ]) ifTrue: [
		^ analyzer visitNode: ((analyzer astBuilder matrix: leftAnalyzedNode multiplicationWith: rightAnalyzedNode)
			position: node)
	].
	
	"Compute the coercion type."
	coercionType := analyzer arithmeticCoercionTypeFor: leftValueType with: rightValueType
		 leftNode: leftAnalyzedNode rightNode: rightAnalyzedNode at: node.

	"Apply the coercion to the operands."
	leftOperand := analyzer addImplicitCastFor: (self ensureLiteralNode: leftAnalyzedNode hasConcreteType: leftValueType coercedTo: coercionType) to: coercionType.
	rightOperand := analyzer addImplicitCastFor: (self ensureLiteralNode: rightAnalyzedNode hasConcreteType: rightValueType coercedTo: coercionType) to: coercionType.
	
	"Create the expanded message send node, and analyze it"
	^ analyzer visitNode: ((analyzer astBuilder
		send: node selector to: leftOperand withArguments: { rightOperand })
		position: node;
		yourself)
]

{ #category : #serialization }
MbndArithmeticOperationCoercionMacro >> materializeWithGraphDecoder: graphDecoder withFields: encodedFields [
]
