Class {
	#name : #MbndSlovimTranslatedIntrinsicThreeWayComparison,
	#superclass : #MbndSlovimTranslatedIntrinsicOperation,
	#category : #'SysmelMoebiusCodeGenerator-Slovim-Module'
}

{ #category : #'as yet unclassified' }
MbndSlovimTranslatedIntrinsicThreeWayComparison >> generateExpandedMessageSendNode: node with: codeGenerator [
	| leftOperand rightOperand resultType resultSSAType operandType |
	leftOperand := codeGenerator visitNode: node receiver.
	rightOperand := codeGenerator visitNode: node arguments first.
	operandType := node receiver type.
	resultType := node type.
	resultSSAType := codeGenerator translateType: resultType.
	^ codeGenerator generateThreeWayComparisonOf: leftOperand with: rightOperand resultType: resultSSAType.

]
