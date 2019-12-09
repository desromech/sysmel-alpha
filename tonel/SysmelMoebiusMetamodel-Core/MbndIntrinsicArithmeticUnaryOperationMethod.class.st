Class {
	#name : #MbndIntrinsicArithmeticUnaryOperationMethod,
	#superclass : #MbndAbstractIntrinsicMethod,
	#classVars : [
		'NonSmalltalkMessageSelectorMap'
	],
	#category : #'SysmelMoebiusMetamodel-Core-Method'
}

{ #category : #'class initialization' }
MbndIntrinsicArithmeticUnaryOperationMethod class >> initialize [
	NonSmalltalkMessageSelectorMap := Dictionary newFromPairs: #(
		#'prefix-!' not
		#'prefix-~' bitInvert
	)
]

{ #category : #visiting }
MbndIntrinsicArithmeticUnaryOperationMethod >> accept: aVisitor [
	^ aVisitor visitIntrinsicArithmeticUnaryOperationMethod: self
]

{ #category : #evaluation }
MbndIntrinsicArithmeticUnaryOperationMethod >> evaluateWithReceiver: receiver arguments: arguments withEvaluator: evaluator at: node [
	| result resultType |
	self assert: receiver isNotNil.
	self assert: arguments isEmpty.

	result := receiver unwrapMbndValue perform: (NonSmalltalkMessageSelectorMap at: name ifAbsent: [name]).
	resultType := self returnType.
	^ MbndValue value: (resultType legalizeLiteralValue: result) type: resultType
]
