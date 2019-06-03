Class {
	#name : #MbndVTablePointerFieldVariable,
	#superclass : #MbndAbstractFieldVariable,
	#category : #'SysmelMoebiusMetamodel-Core-Variables'
}

{ #category : #visiting }
MbndVTablePointerFieldVariable >> accept: aVisitor [
	^ aVisitor visitVTablePointerFieldVariable: self
]

{ #category : #testing }
MbndVTablePointerFieldVariable >> isVTablePointerField [
	^ true
]
