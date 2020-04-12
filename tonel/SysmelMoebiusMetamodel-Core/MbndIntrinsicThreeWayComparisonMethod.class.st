Class {
	#name : #MbndIntrinsicThreeWayComparisonMethod,
	#superclass : #MbndIntrinsicArithmeticBinaryOperationMethod,
	#category : #'SysmelMoebiusMetamodel-Core-Method'
}

{ #category : #serialization }
MbndIntrinsicThreeWayComparisonMethod class >> messagePackTypeName [
	^ #IntrinsicThreeWayComparisonMethod
]

{ #category : #visiting }
MbndIntrinsicThreeWayComparisonMethod >> accept: aVisitor [
	^ aVisitor visitIntrinsicThreeWayComparisonMethod: self
]
