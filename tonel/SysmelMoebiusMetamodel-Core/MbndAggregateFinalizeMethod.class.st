Class {
	#name : #MbndAggregateFinalizeMethod,
	#superclass : #MbndCompilerGeneratedMethod,
	#category : #'SysmelMoebiusMetamodel-Core-Method'
}

{ #category : #serialization }
MbndAggregateFinalizeMethod class >> messagePackTypeName [
	^ #AggregateFinalizeMethod
]

{ #category : #visiting }
MbndAggregateFinalizeMethod >> accept: aVisitor [
	^ aVisitor visitAggregateFinalizeMethod: self
]
