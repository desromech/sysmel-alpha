Class {
	#name : #MbndAggregateInitializeFromCopyMethod,
	#superclass : #MbndCompilerGeneratedMethod,
	#category : #'SysmelMoebiusMetamodel-Core-Method'
}

{ #category : #serialization }
MbndAggregateInitializeFromCopyMethod class >> messagePackTypeName [
	^ #AggregateInitializeFromCopyMethod
]

{ #category : #visiting }
MbndAggregateInitializeFromCopyMethod >> accept: aVisitor [
	^ aVisitor visitAggregateInitializeFromCopyMethod: self
]
