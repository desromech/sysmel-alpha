Class {
	#name : #MbndFunctionGroup,
	#superclass : #MbndAbstractMethodGroup,
	#category : #'SysmelMoebiusMetamodel-Core-Method'
}

{ #category : #serialization }
MbndFunctionGroup class >> messagePackTypeName [
	^ #FunctionGroup
]

{ #category : #visiting }
MbndFunctionGroup >> accept: aVisitor [
	^ aVisitor visitFunctionGroup: self
]
