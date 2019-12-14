Class {
	#name : #MbndAggregateFinalizeMethod,
	#superclass : #MbndCompilerGeneratedMethod,
	#category : #'SysmelMoebiusMetamodel-Core-Method'
}

{ #category : #visiting }
MbndAggregateFinalizeMethod >> accept: aVisitor [
	^ aVisitor visitAggregateFinalizeMethod: self
]
