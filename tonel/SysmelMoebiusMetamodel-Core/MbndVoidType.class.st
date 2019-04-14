Class {
	#name : #MbndVoidType,
	#superclass : #MbndOpaqueType,
	#category : #'SysmelMoebiusMetamodel-Core-Type'
}

{ #category : #'as yet unclassified' }
MbndVoidType class >> typeName [
	^ #Void
]

{ #category : #testing }
MbndVoidType >> isVoidType [
	^ true
]
