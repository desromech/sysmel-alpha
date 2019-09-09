Class {
	#name : #MbndArithmeticOperationCoercionMacro,
	#superclass : #MbndAbstractMacro,
	#category : #'SysmelMoebiusMetamodel-Core-Macro'
}

{ #category : #'as yet unclassified' }
MbndArithmeticOperationCoercionMacro >> ensureLiteralNode: literalNode hasConcreteType: literalConcreteType [
	literalNode isLiteralValueNode ifFalse: [ ^ literalNode ].
	literalNode type = literalConcreteType ifTrue: [ ^ literalNode ].
	^ literalNode copy type: literalConcreteType
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
	leftValueType := leftAnalyzedNode type bestConcreteTypeForLiteralValueNode: leftAnalyzedNode inScope: analyzer scope.
	rightValueType := rightAnalyzedNode type bestConcreteTypeForLiteralValueNode: rightAnalyzedNode inScope: analyzer scope.
	
	"Compute the coercion type."
	coercionType := analyzer arithmeticCoercionTypeFor: leftValueType with: rightValueType at: node.

	"Apply the coercion to the operands."
	leftOperand := analyzer addImplicitCastFor: (self ensureLiteralNode: leftAnalyzedNode hasConcreteType: leftValueType) to: coercionType.
	rightOperand := analyzer addImplicitCastFor: (self ensureLiteralNode: rightAnalyzedNode hasConcreteType: rightValueType) to: coercionType.
	
	"Create the expanded message send node, and analyze it"
	^ analyzer visitNode: ((analyzer astBuilder
		send: node selector to: leftOperand withArguments: { rightOperand })
		position: node;
		yourself)
]
