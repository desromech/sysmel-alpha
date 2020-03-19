Class {
	#name : #MbndAggregateInitializeMovingFromMethod,
	#superclass : #MbndCompilerGeneratedMethod,
	#category : #'SysmelMoebiusMetamodel-Core-Method'
}

{ #category : #serialization }
MbndAggregateInitializeMovingFromMethod class >> messagePackTypeName [
	^ #AggregateMovingFromMethod
]

{ #category : #visiting }
MbndAggregateInitializeMovingFromMethod >> accept: aVisitor [
	^ aVisitor visitAggregateInitializeMovingFromMethod: self
]
