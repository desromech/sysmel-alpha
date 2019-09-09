Class {
	#name : #MbndSlovimTranslatedIntrinsicArithmeticUnaryOperation,
	#superclass : #MbndSlovimTranslatedIntrinsicOperation,
	#classVars : [
		'BooleanOperationMap',
		'FloatingPointOperationMap',
		'IntegerOperationMap'
	],
	#category : #'SysmelMoebiusCodeGenerator-Slovim-Module'
}

{ #category : #'class initialization' }
MbndSlovimTranslatedIntrinsicArithmeticUnaryOperation class >> initialize [
	BooleanOperationMap := Dictionary newFromPairs: #(
		lnot lnot
	).
	IntegerOperationMap := Dictionary newFromPairs: #(
		lnot lnot
		not not
		neg neg
	).
	FloatingPointOperationMap := Dictionary newFromPairs: #(
		neg fneg
		sqrt fsqrt
	).
	
]

{ #category : #'as yet unclassified' }
MbndSlovimTranslatedIntrinsicArithmeticUnaryOperation >> generateExpandedMessageSendNode: node with: codeGenerator [
	| intrinsicName resultType operand |
	intrinsicName := self intrinsicName.
	resultType := node type.
	operand := codeGenerator visitNode: node receiver.

	resultType isPrimitiveBooleanType ifTrue: [
		^ codeGenerator slvmBuilder addOperation: (BooleanOperationMap at: intrinsicName) operand: operand
	].
	resultType isPrimitiveIntegerType ifTrue: [
		intrinsicName = #lowBit ifTrue: [ ^ codeGenerator slvmBuilder lowBit: operand ].
		intrinsicName = #highBit ifTrue: [ ^ codeGenerator slvmBuilder highBit: operand ].
		^ codeGenerator slvmBuilder addOperation: (IntegerOperationMap at: intrinsicName) operand: operand
	].
	resultType isPrimitiveFloatType ifTrue: [ 
		^ codeGenerator slvmBuilder addOperation: (FloatingPointOperationMap at: intrinsicName) operand: operand
	].

	self error: 'Unsupported operand type.'
]
