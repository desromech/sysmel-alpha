Class {
	#name : #MbndReturnType,
	#superclass : #MbndVoidType,
	#category : #'SysmelMoebiusMetamodel-Core-Type'
}

{ #category : #accessing }
MbndReturnType class >> typeName [
	^ #_ReturnType
]

{ #category : #visiting }
MbndReturnType >> accept: aVisitor [
	^ aVisitor visitReturnType: self
]

{ #category : #'type inference' }
MbndReturnType >> inferValueTypeForNode: initialValueNode inScope: scope [
	^ self compilationTarget voidType
]

{ #category : #testing }
MbndReturnType >> isReturnType [
	^ true
]
