Class {
	#name : #MbndIntrinsicPointerComparisonMethod,
	#superclass : #MbndAbstractIntrinsicMethod,
	#category : #'SysmelMoebiusMetamodel-Core-Method'
}

{ #category : #visiting }
MbndIntrinsicPointerComparisonMethod >> accept: aVisitor [
	^ aVisitor visitIntrinsicPointerComparisonMethod: self
]
