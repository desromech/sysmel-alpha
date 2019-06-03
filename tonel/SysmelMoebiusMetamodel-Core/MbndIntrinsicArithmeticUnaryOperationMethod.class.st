Class {
	#name : #MbndIntrinsicArithmeticUnaryOperationMethod,
	#superclass : #MbndAbstractIntrinsicMethod,
	#category : #'SysmelMoebiusMetamodel-Core-Method'
}

{ #category : #visiting }
MbndIntrinsicArithmeticUnaryOperationMethod >> accept: aVisitor [
	^ aVisitor visitIntrinsicArithmeticUnaryOperationMethod: self
]

{ #category : #evaluation }
MbndIntrinsicArithmeticUnaryOperationMethod >> evaluateWithReceiver: receiver arguments: arguments withEvaluator: evaluator at: node [
	| result resultType |
	self assert: receiver isNotNil.
	self assert: arguments isEmpty.

	result := receiver unwrapMbndValue perform: name.
	resultType := self returnType.
	^ MbndValue value: (resultType legalizeLiteralValue: result) type: resultType
]
