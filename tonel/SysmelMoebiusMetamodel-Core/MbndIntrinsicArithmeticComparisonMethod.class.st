Class {
	#name : #MbndIntrinsicArithmeticComparisonMethod,
	#superclass : #MbndIntrinsicArithmeticBinaryOperationMethod,
	#category : #'SysmelMoebiusMetamodel-Core-Method'
}

{ #category : #serialization }
MbndIntrinsicArithmeticComparisonMethod class >> messagePackTypeName [
	^ #IntrinsicArithmeticComparisonMethod
]

{ #category : #visiting }
MbndIntrinsicArithmeticComparisonMethod >> accept: aVisitor [
	^ aVisitor visitIntrinsicArithmeticComparisonMethod: self
]
