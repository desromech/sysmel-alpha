Class {
	#name : #MbndConstructorGroup,
	#superclass : #MbndAbstractMethodGroup,
	#category : #'SysmelMoebiusMetamodel-Core-Method'
}

{ #category : #serialization }
MbndConstructorGroup class >> messagePackTypeName [
	^ #ConstructorGroup
]

{ #category : #visiting }
MbndConstructorGroup >> accept: aVisitor [
	^ aVisitor visitConstructorGroup: self
]
