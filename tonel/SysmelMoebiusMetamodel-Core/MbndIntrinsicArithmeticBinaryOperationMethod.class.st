Class {
	#name : #MbndIntrinsicArithmeticBinaryOperationMethod,
	#superclass : #MbndAbstractIntrinsicMethod,
	#category : #'SysmelMoebiusMetamodel-Core-Method'
}

{ #category : #visiting }
MbndIntrinsicArithmeticBinaryOperationMethod >> accept: aVisitor [
	^ aVisitor visitIntrinsicArithmeticBinaryOperationMethod: self
]

{ #category : #evaluation }
MbndIntrinsicArithmeticBinaryOperationMethod >> evaluateWithReceiver: receiver arguments: arguments withEvaluator: evaluator at: node [
	| result resultType |
	self assert: receiver isNotNil.
	self assert: arguments size = 1.

	result := receiver unwrapMbndValue perform: name with: arguments first unwrapMbndValue.
	resultType := self returnType.
	^ MbndValue value: (resultType legalizeLiteralValue: result) type: resultType
]
