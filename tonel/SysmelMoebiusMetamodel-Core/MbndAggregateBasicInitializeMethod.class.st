Class {
	#name : #MbndAggregateBasicInitializeMethod,
	#superclass : #MbndCompilerGeneratedMethod,
	#category : #'SysmelMoebiusMetamodel-Core-Method'
}

{ #category : #serialization }
MbndAggregateBasicInitializeMethod class >> messagePackTypeName [
	^ #AggregateBasicInitializeMethod
]

{ #category : #visiting }
MbndAggregateBasicInitializeMethod >> accept: aVisitor [
	^ aVisitor visitAggregateBasicInitializeMethod: self
]
