Class {
	#name : #MbndSlovimTranslatedIntrinsicThreeWayComparison,
	#superclass : #MbndSlovimTranslatedIntrinsicOperation,
	#category : #'SysmelMoebiusCodeGenerator-Slovim-Module'
}

{ #category : #'as yet unclassified' }
MbndSlovimTranslatedIntrinsicThreeWayComparison >> generateExpandedMessageSendNode: node with: codeGenerator [
	| leftOperand rightOperand elementType resultType resultSSAType builder result operandType signIntrinsic |
	leftOperand := codeGenerator visitNode: node receiver.
	rightOperand := codeGenerator visitNode: node arguments first.
	operandType := node receiver type.
	resultType := node type.
	resultSSAType := codeGenerator translateType: resultType.

	elementType := node receiver type.
	elementType isEnumType ifTrue: [ elementType := elementType baseType ].
	elementType isPrimitiveScalarType ifFalse: [ elementType := elementType elementType ].
	builder := codeGenerator slvmBuilder.

	elementType isPointerType ifTrue: [
		| intPointerSSAType |
		elementType := codeGenerator compilationTarget intPointerType.
		intPointerSSAType := codeGenerator translateType: elementType.
		leftOperand := builder pointerToIntCast: leftOperand target: intPointerSSAType.
		rightOperand := builder pointerToIntCast: rightOperand target: intPointerSSAType.
	].

	elementType isPrimitiveBooleanType ifTrue: [
		leftOperand := builder zeroExtend: leftOperand target: resultSSAType.
		rightOperand := builder zeroExtend: rightOperand target: resultSSAType.
		^ builder sub: leftOperand with: rightOperand
	].

	elementType isPrimitiveIntegerType ifTrue: [ 
		result := builder sub: leftOperand with: rightOperand.
		elementType ~~ resultType ifTrue: [
			elementType instanceSize = resultType instanceSize ifTrue: [
				result := builder bitCast: result target: resultSSAType
			] ifFalse: [
				elementType instanceSize < resultType instanceSize ifTrue: [ 
					result := builder signExtend: result target: resultSSAType
				] ifFalse: [ 
					result := builder truncate: result target: resultSSAType
				]
			]
		].
	
		^ result
	].

	elementType isPrimitiveFloatType ifTrue: [
		result := builder fsub: leftOperand with: rightOperand.
		signIntrinsic := codeGenerator codeModuleGenerator intrinsicConstantBuiltInFunction: #'math.fsign' withType: operandType => operandType.
		result := builder call: signIntrinsic arguments: { result }.
		^ builder floatToIntCast: result target: resultSSAType.
	].

	self error.
]
