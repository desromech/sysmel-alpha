Class {
	#name : #MbndIntrinsicThreeWayComparisonMethod,
	#superclass : #MbndIntrinsicArithmeticBinaryOperationMethod,
	#category : #'SysmelMoebiusMetamodel-Core-Method'
}

{ #category : #visiting }
MbndIntrinsicThreeWayComparisonMethod >> accept: aVisitor [
	^ aVisitor visitIntrinsicThreeWayComparisonMethod: self
]
