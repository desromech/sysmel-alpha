Class {
	#name : #MbndVoidType,
	#superclass : #MbndNativeType,
	#category : #'MoebiusBandMetamodel-Core-Type'
}

{ #category : #'as yet unclassified' }
MbndVoidType class >> typeName [
	^ #Void
]

{ #category : #testing }
MbndVoidType >> isVoidType [
	^ true
]
