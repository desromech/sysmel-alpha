Class {
	#name : #MbndFunctionGroup,
	#superclass : #MbndAbstractMethodGroup,
	#category : #'SysmelMoebiusMetamodel-Core-Method'
}

{ #category : #visiting }
MbndFunctionGroup >> accept: aVisitor [
	^ aVisitor visitFunctionGroup: self
]
