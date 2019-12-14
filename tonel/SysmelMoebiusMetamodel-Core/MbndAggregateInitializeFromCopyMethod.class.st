Class {
	#name : #MbndAggregateInitializeFromCopyMethod,
	#superclass : #MbndCompilerGeneratedMethod,
	#category : #'SysmelMoebiusMetamodel-Core-Method'
}

{ #category : #visiting }
MbndAggregateInitializeFromCopyMethod >> accept: aVisitor [
	^ aVisitor visitAggregateInitializeFromCopyMethod: self
]
