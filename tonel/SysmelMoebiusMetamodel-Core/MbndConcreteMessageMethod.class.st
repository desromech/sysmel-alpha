Class {
	#name : #MbndConcreteMessageMethod,
	#superclass : #MbndAbstractConcreteMethod,
	#category : #'SysmelMoebiusMetamodel-Core-Method'
}

{ #category : #visiting }
MbndConcreteMessageMethod >> accept: aVisitor [
	^ aVisitor visitConcreteMessageMethod: self
]
