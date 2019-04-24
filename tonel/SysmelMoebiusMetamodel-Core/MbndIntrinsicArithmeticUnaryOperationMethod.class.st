Class {
	#name : #MbndIntrinsicArithmeticUnaryOperationMethod,
	#superclass : #MbndAbstractIntrinsicMethod,
	#category : #'SysmelMoebiusMetamodel-Core-Method'
}

{ #category : #evaluation }
MbndIntrinsicArithmeticUnaryOperationMethod >> evaluateWithReceiver: receiver arguments: arguments withEvaluator: evaluator at: node [
	| result |
	self assert: receiver isNotNil.
	self assert: arguments isEmpty.

	result := receiver unwrapMbndValue perform: name.
	^ MbndValue value: result type: self returnType
]
