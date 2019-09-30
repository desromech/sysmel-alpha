Class {
	#name : #MbndMessageGroup,
	#superclass : #MbndAbstractMethodGroup,
	#category : #'SysmelMoebiusMetamodel-Core-Method'
}

{ #category : #visiting }
MbndMessageGroup >> accept: aVisitor [
	^ aVisitor visitMessageGroup: self
]
