Class {
	#name : #MbndSlovimTranslatedIntrinsicPointerComparisonOperation,
	#superclass : #MbndSlovimTranslatedIntrinsicOperation,
	#classVars : [
		'PointerOperationMap'
	],
	#category : #'SysmelMoebiusCodeGenerator-Slovim-Module'
}

{ #category : #'class initialization' }
MbndSlovimTranslatedIntrinsicPointerComparisonOperation class >> initialize [
	PointerOperationMap := Dictionary newFromPairs: #(
		eq ieq
		ne ine
		lt ult
		le ule
		ge uge
		gt ugt
	).
]

{ #category : #'as yet unclassified' }
MbndSlovimTranslatedIntrinsicPointerComparisonOperation >> generateExpandedMessageSendNode: node with: codeGenerator [
	| intrinsicName leftOperand rightOperand operandType |
	intrinsicName := self intrinsicName.
	operandType := node receiver type.
	operandType isUndefinedType ifTrue: [
		^ codeGenerator slvmBuilder constBool: (
			#(eq le ge) includes: intrinsicName
		)
	].

	leftOperand := codeGenerator visitNode: node receiver.
	rightOperand := codeGenerator visitNode: node arguments first.
	
	^ codeGenerator slvmBuilder addOperation: (PointerOperationMap at: intrinsicName) left: leftOperand right: rightOperand
]
