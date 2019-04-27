Class {
	#name : #MbndVoidType,
	#superclass : #MbndOpaqueType,
	#category : #'SysmelMoebiusMetamodel-Core-Type'
}

{ #category : #'as yet unclassified' }
MbndVoidType class >> typeName [
	^ #Void
]

{ #category : #'default values' }
MbndVoidType >> defaultValue [
	^ MbndValue value: nil type: self
]

{ #category : #testing }
MbndVoidType >> isVoidType [
	^ true
]