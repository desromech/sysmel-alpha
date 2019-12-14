Class {
	#name : #MbndAggregateInitializeMovingFromMethod,
	#superclass : #MbndCompilerGeneratedMethod,
	#category : #'SysmelMoebiusMetamodel-Core-Method'
}

{ #category : #visiting }
MbndAggregateInitializeMovingFromMethod >> accept: aVisitor [
	^ aVisitor visitAggregateInitializeMovingFromMethod: self
]
