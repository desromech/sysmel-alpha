Class {
	#name : #MbndIntrinsicArithmeticBinaryOperationMethod,
	#superclass : #MbndIntrinsicArithmeticComparisonMethod,
	#category : #'SysmelMoebiusMetamodel-Core-Method'
}

{ #category : #evaluation }
MbndIntrinsicArithmeticBinaryOperationMethod >> evaluateWithReceiver: receiver arguments: arguments withEvaluator: evaluator at: node [
	| result |
	self assert: receiver isNotNil.
	self assert: arguments size = 1.

	result := receiver unwrapMbndValue perform: name with: arguments first unwrapMbndValue.
	^ MbndValue value: result type: self returnType
]
