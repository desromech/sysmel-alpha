Class {
	#name : #MbndMessageGroup,
	#superclass : #MbndAbstractMethodGroup,
	#category : #'SysmelMoebiusMetamodel-Core-Method'
}

{ #category : #serialization }
MbndMessageGroup class >> messagePackTypeName [
	^ #MessageGroup
]

{ #category : #visiting }
MbndMessageGroup >> accept: aVisitor [
	^ aVisitor visitMessageGroup: self
]
