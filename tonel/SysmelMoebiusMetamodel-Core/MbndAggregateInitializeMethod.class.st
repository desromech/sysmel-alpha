Class {
	#name : #MbndAggregateInitializeMethod,
	#superclass : #MbndCompilerGeneratedMethod,
	#category : #'SysmelMoebiusMetamodel-Core-Method'
}

{ #category : #visiting }
MbndAggregateInitializeMethod >> accept: aVisitor [
	^ aVisitor visitAggregateInitializeMethod: self
]
