Class {
	#name : #MbndSlovimTranslatedIntrinsicArithmeticBinaryOperation,
	#superclass : #MbndSlovimTranslatedIntrinsicOperation,
	#classVars : [
		'FloatingPointOperationMap',
		'SignedIntegerOperationMap',
		'UnsignedIntegerOperationMap'
	],
	#category : #'SysmelMoebiusCodeGenerator-Slovim-Module'
}

{ #category : #'class initialization' }
MbndSlovimTranslatedIntrinsicArithmeticBinaryOperation class >> initialize [
	super initialize.
	
	SignedIntegerOperationMap := Dictionary newFromPairs: #(
		add add
		sub sub
		mul mul
		div div
		idiv div
		irem rem
		rem rem

		bitand bitand
		bitor bitor
		bitxor bitxor

		shiftleft shiftleft
		shiftright shiftrightarithmetic
		rotateleft rotateleft
		rotateright rotateleft
	).
	
	UnsignedIntegerOperationMap := Dictionary newFromPairs: #(
		add add
		sub sub
		mul mul
		div udiv
		idiv udiv
		irem urem
		rem urem
		
		bitand bitand
		bitor bitor
		bitxor bitxor

		shiftleft shiftleft
		shiftright shiftright
		rotateleft rotateleft
		rotateright rotateleft
	).
	
	FloatingPointOperationMap := Dictionary newFromPairs: #(
		add fadd
		sub fsub
		mul fmul
		div fdiv
		rem frem
	).
]

{ #category : #'as yet unclassified' }
MbndSlovimTranslatedIntrinsicArithmeticBinaryOperation >> generateExpandedMessageSendNode: node with: codeGenerator [
	| intrinsicName resultType leftOperand rightOperand |
	intrinsicName := self intrinsicName.
	resultType := node type.
	leftOperand := codeGenerator visitNode: node receiver.
	rightOperand := codeGenerator visitNode: node arguments first.
	
	resultType isPrimitiveIntegerType ifTrue: [
		^ resultType isSigned ifTrue: [
			codeGenerator slvmBuilder addOperation: (SignedIntegerOperationMap at: intrinsicName) left: leftOperand right: rightOperand
		] ifFalse: [
			codeGenerator slvmBuilder addOperation: (UnsignedIntegerOperationMap at: intrinsicName) left: leftOperand right: rightOperand
		]
	].
	resultType isPrimitiveFloatType ifTrue: [ 
		^ codeGenerator slvmBuilder addOperation: (FloatingPointOperationMap at: intrinsicName) left: leftOperand right: rightOperand
	].

	self error: 'Unsupported operand type.'
]
