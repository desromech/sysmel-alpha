Class {
	#name : #MbndVoidType,
	#superclass : #MbndOpaqueType,
	#category : #'SysmelMoebiusMetamodel-Core-Type'
}

{ #category : #'as yet unclassified' }
MbndVoidType class >> typeName [
	^ #Void
]

{ #category : #visiting }
MbndVoidType >> accept: aVisitor [
	^ aVisitor visitVoidType: self
]

{ #category : #'default values' }
MbndVoidType >> defaultValueAt: aPosition [
	^ MbndValue value: nil type: self
]

{ #category : #testing }
MbndVoidType >> isVoidType [
	<compileTime>
	^ true
]
