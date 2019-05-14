Class {
	#name : #MbndGCClassType,
	#superclass : #MbndAbstractClassType,
	#category : #'SysmelMoebiusMetamodel-Core-Type'
}

{ #category : #accessing }
MbndGCClassType class >> typeName [
	^ #_GCClassType
]

{ #category : #visiting }
MbndGCClassType >> accept: aVisitor [
	^ aVisitor visitGCClassType: self
]

{ #category : #testing }
MbndGCClassType >> isGCClassType [
	^ true
]
