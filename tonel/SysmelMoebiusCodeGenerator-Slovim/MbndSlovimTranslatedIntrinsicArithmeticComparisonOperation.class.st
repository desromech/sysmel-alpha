Class {
	#name : #MbndSlovimTranslatedIntrinsicArithmeticComparisonOperation,
	#superclass : #MbndSlovimTranslatedIntrinsicOperation,
	#classVars : [
		'FloatingPointOperationMap',
		'SignedIntegerOperationMap',
		'UnsignedIntegerOperationMap'
	],
	#category : #'SysmelMoebiusCodeGenerator-Slovim-Module'
}

{ #category : #'class initialization' }
MbndSlovimTranslatedIntrinsicArithmeticComparisonOperation class >> initialize [
	super initialize.
	
	SignedIntegerOperationMap := Dictionary newFromPairs: #(
		eq ieq
		ne ine
		lt ilt
		le ile
		ge ige
		gt igt
	).
	
	UnsignedIntegerOperationMap := Dictionary newFromPairs: #(
		eq ieq
		ne ine
		lt ult
		le ule
		ge uge
		gt ugt
	).
	
	FloatingPointOperationMap := Dictionary newFromPairs: #(
		eq ufeq
		ne ufne
		lt uflt
		le ufle
		ge ufe
		gt ufgt
	).
]

{ #category : #'as yet unclassified' }
MbndSlovimTranslatedIntrinsicArithmeticComparisonOperation >> generateExpandedMessageSendNode: node with: codeGenerator [
	| intrinsicName resultType leftOperand rightOperand operandType |
	intrinsicName := self intrinsicName.
	operandType := node receiver type.
	leftOperand := codeGenerator visitNode: node receiver.
	rightOperand := codeGenerator visitNode: node arguments first.
	
	operandType isPrimitiveIntegerType ifTrue: [
		^ operandType isSigned ifTrue: [
			codeGenerator slvmBuilder addOperation: (SignedIntegerOperationMap at: intrinsicName) left: leftOperand right: rightOperand
		] ifFalse: [
			codeGenerator slvmBuilder addOperation: (UnsignedIntegerOperationMap at: intrinsicName) left: leftOperand right: rightOperand
		]
	].
	operandType isPrimitiveFloatType ifTrue: [ 
		^ codeGenerator slvmBuilder addOperation: (FloatingPointOperationMap at: intrinsicName) left: leftOperand right: rightOperand
	].

	self error: 'Unsupported operand type.'
]
