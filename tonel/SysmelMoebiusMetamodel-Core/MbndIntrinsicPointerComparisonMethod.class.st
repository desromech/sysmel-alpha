Class {
	#name : #MbndIntrinsicPointerComparisonMethod,
	#superclass : #MbndAbstractIntrinsicMethod,
	#category : #'SysmelMoebiusMetamodel-Core-Method'
}

{ #category : #serialization }
MbndIntrinsicPointerComparisonMethod class >> messagePackTypeName [
	^ #IntrinsicPointerComparisonMethod
]

{ #category : #visiting }
MbndIntrinsicPointerComparisonMethod >> accept: aVisitor [
	^ aVisitor visitIntrinsicPointerComparisonMethod: self
]
