Class {
	#name : #MbndIntrinsicArithmeticComparisonMethod,
	#superclass : #MbndIntrinsicArithmeticBinaryOperationMethod,
	#category : #'SysmelMoebiusMetamodel-Core-Method'
}

{ #category : #visiting }
MbndIntrinsicArithmeticComparisonMethod >> accept: aVisitor [
	^ aVisitor visitIntrinsicArithmeticComparisonMethod: self
]
