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
MbndSlovimTranslatedIntrinsicArithmeticUnaryOperation >> generateElementWiseMessageSendNode: node with: codeGenerator [
	| intrinsicName resultType scalarType operand |
	intrinsicName := self intrinsicName.
	resultType := node type.
	operand := codeGenerator visitNode: node receiver.
	
	scalarType := resultType.
	scalarType isEnumType ifTrue: [ 
		scalarType := scalarType baseType.
	].

	(scalarType isPrimitiveVectorType or: [ scalarType isPrimitiveMatrixType ]) ifTrue: [
		scalarType := scalarType elementType
	].

	scalarType isPrimitiveBooleanType ifTrue: [
		^ codeGenerator slvmBuilder addOperation: (BooleanOperationMap at: intrinsicName) operand: operand
	].
	scalarType isPrimitiveIntegerType ifTrue: [
		intrinsicName = #lowBit ifTrue: [ ^ codeGenerator slvmBuilder lowBit: operand ].
		intrinsicName = #highBit ifTrue: [ ^ codeGenerator slvmBuilder highBit: operand ].
		^ codeGenerator slvmBuilder addOperation: (IntegerOperationMap at: intrinsicName) operand: operand
	].
	scalarType isPrimitiveFloatType ifTrue: [ 
		^ codeGenerator slvmBuilder addOperation: (FloatingPointOperationMap at: intrinsicName) operand: operand
	].

	self error: 'Unsupported operand type.'
]

{ #category : #'as yet unclassified' }
MbndSlovimTranslatedIntrinsicArithmeticUnaryOperation >> generateExpandedMessageSendNode: node with: codeGenerator [
	| intrinsicName resultType scalarType operand |
	intrinsicName := self intrinsicName.
	resultType := node type.
	operand := codeGenerator visitNode: node receiver.
	
	scalarType := resultType.
	scalarType isEnumType ifTrue: [ 
		scalarType := scalarType baseType.
	].

	(scalarType isPrimitiveVectorType or: [ scalarType isPrimitiveMatrixType ]) ifTrue: [
		scalarType := scalarType elementType
	].

	scalarType isPrimitiveBooleanType ifTrue: [
		^ codeGenerator slvmBuilder addOperation: (BooleanOperationMap at: intrinsicName) operand: operand
	].
	scalarType isPrimitiveIntegerType ifTrue: [
		intrinsicName = #lowBit ifTrue: [ ^ codeGenerator slvmBuilder lowBit: operand ].
		intrinsicName = #highBit ifTrue: [ ^ codeGenerator slvmBuilder highBit: operand ].
		^ codeGenerator slvmBuilder addOperation: (IntegerOperationMap at: intrinsicName) operand: operand
	].
	scalarType isPrimitiveFloatType ifTrue: [ 
		^ codeGenerator slvmBuilder addOperation: (FloatingPointOperationMap at: intrinsicName) operand: operand
	].

	self error: 'Unsupported operand type.'
]
