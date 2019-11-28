Class {
	#name : #MbndAggregateBasicInitializeMethod,
	#superclass : #MbndCompilerGeneratedMethod,
	#category : #'SysmelMoebiusMetamodel-Core-Method'
}

{ #category : #visiting }
MbndAggregateBasicInitializeMethod >> accept: aVisitor [
	^ aVisitor visitAggregateBasicInitializeMethod: self
]
