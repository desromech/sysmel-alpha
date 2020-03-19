Class {
	#name : #MbndAggregateInitializeMethod,
	#superclass : #MbndCompilerGeneratedMethod,
	#category : #'SysmelMoebiusMetamodel-Core-Method'
}

{ #category : #serialization }
MbndAggregateInitializeMethod class >> messagePackTypeName [
	^ #AggregateInitializeMethodMethod
]

{ #category : #visiting }
MbndAggregateInitializeMethod >> accept: aVisitor [
	^ aVisitor visitAggregateInitializeMethod: self
]
