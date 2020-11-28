Class {
	#name : #MbndSlovimTranslatedIntrinsicArithmeticComparisonOperation,
	#superclass : #MbndSlovimTranslatedIntrinsicOperation,
	#classVars : [
		'BooleanOperationMap',
		'FloatingPointOperationMap',
		'SignedIntegerOperationMap',
		'UnsignedIntegerOperationMap'
	],
	#category : #'SysmelMoebiusCodeGenerator-Slovim-Module'
}

{ #category : #'class initialization' }
MbndSlovimTranslatedIntrinsicArithmeticComparisonOperation class >> initialize [
	super initialize.

	BooleanOperationMap := Dictionary newFromPairs: #(
		eq ieq
		ne ine
		lt ult
		le ule
		ge uge
		gt ugt
	).
	
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
		eq ofeq
		ne ofne
		lt oflt
		le ofle
		ge ofge
		gt ofgt
	).
]

{ #category : #'as yet unclassified' }
MbndSlovimTranslatedIntrinsicArithmeticComparisonOperation >> generateElementWiseMessageSendNode: node with: codeGenerator [
	| intrinsicName leftOperand rightOperand operandType |
	intrinsicName := self intrinsicName.
	operandType := node receiver type.
	operandType isEnumType ifTrue: [ operandType := operandType baseType ].
	operandType isPrimitiveScalarType ifFalse: [ operandType := operandType elementType ].
	
	leftOperand := codeGenerator visitNode: node receiver.
	rightOperand := codeGenerator visitNode: node arguments first.
	
	operandType isPrimitiveBooleanType ifTrue: [ 
		^ codeGenerator slvmBuilder addOperation: (BooleanOperationMap at: intrinsicName) left: leftOperand right: rightOperand
	].

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

{ #category : #'as yet unclassified' }
MbndSlovimTranslatedIntrinsicArithmeticComparisonOperation >> generateExpandedMessageSendNode: node with: codeGenerator [
	| result resultType operandType |
	operandType := node receiver type.
	operandType isEnumType ifTrue: [ operandType := operandType baseType ].
	((operandType isPrimitiveVectorType or: [ operandType isPrimitiveMatrixType ])
	 and: [node type isPrimitiveBooleanType]) ifTrue: [
		(#(eq ne) includes: self intrinsicName) ifFalse: [
			^ self generateSyntheticVectorComparisonNode: node with: codeGenerator
		]
	].

	result := self generateElementWiseMessageSendNode: node with: codeGenerator.
	node type isPrimitiveScalarType ifTrue: [ 
		resultType := result type.
		resultType isVectorType ifTrue: [
			self intrinsicName = #eq ifTrue: [
				result := codeGenerator slvmBuilder vectorIsAllSet: result
			] ifFalse: [ 
				self assert: self intrinsicName = #ne.
				result := codeGenerator slvmBuilder vectorIsAnySet: result
			] 
		].
		resultType isMatrixType ifTrue: [
			self intrinsicName = #eq ifTrue: [
				result := codeGenerator slvmBuilder matrixIsAllSet: result
			] ifFalse: [ 
				self assert: self intrinsicName = #ne.
				result := codeGenerator slvmBuilder matrixIsAnySet: result
			] 
		].
	].

	^ result
]

{ #category : #'as yet unclassified' }
MbndSlovimTranslatedIntrinsicArithmeticComparisonOperation >> generateSyntheticVectorComparisonNode: node with: codeGenerator [
	| leftOperand rightOperand comparisonResult zeroConstant builder intrinsic |
	leftOperand := codeGenerator visitNode: node receiver.
	rightOperand := codeGenerator visitNode: node arguments first.
	comparisonResult := codeGenerator generateThreeWayComparisonOf: leftOperand with: rightOperand resultType: SLVMType intType.
	zeroConstant := comparisonResult type defaultConstant.
	builder := codeGenerator slvmBuilder.
	
	intrinsic := self intrinsicName.
	intrinsic = #eq ifTrue: [
		^ builder ieq: comparisonResult with: zeroConstant
	].
	intrinsic = #ne ifTrue: [
		^ builder ine: comparisonResult with: zeroConstant
	].
	intrinsic = #lt ifTrue: [
		^ builder ilt: comparisonResult with: zeroConstant
	].
	intrinsic = #le ifTrue: [
		^ builder ile: comparisonResult with: zeroConstant
	].
	intrinsic = #gt ifTrue: [
		^ builder igt: comparisonResult with: zeroConstant
	].
	intrinsic = #ge ifTrue: [
		^ builder ige: comparisonResult with: zeroConstant
	].
	self error
]
