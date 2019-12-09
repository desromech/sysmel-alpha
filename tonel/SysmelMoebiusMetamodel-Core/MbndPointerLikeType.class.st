Class {
	#name : #MbndPointerLikeType,
	#superclass : #MbndDerivedType,
	#instVars : [
		'addressSpace'
	],
	#category : #'SysmelMoebiusMetamodel-Core-Type'
}

{ #category : #'as yet unclassified' }
MbndPointerLikeType class >> functionAddressSpace [
	^ SLVMType functionStorage
]

{ #category : #'as yet unclassified' }
MbndPointerLikeType class >> genericAddressSpace [
	^ SLVMType genericStorage
]

{ #category : #accessing }
MbndPointerLikeType class >> typeName [
	^ #_PointerLikeType
]

{ #category : #accessing }
MbndPointerLikeType >> addressSpace [
	^ addressSpace
]

{ #category : #accessing }
MbndPointerLikeType >> addressSpace: anObject [
	addressSpace := anObject
]

{ #category : #converting }
MbndPointerLikeType >> asPointerType [
	self subclassResponsibility
]

{ #category : #converting }
MbndPointerLikeType >> asReferenceType [
	self subclassResponsibility
]

{ #category : #converting }
MbndPointerLikeType >> asUndecoratedClassType [
	^ baseType asUndecoratedClassType
]

{ #category : #sizes }
MbndPointerLikeType >> instanceAlignment [
	<compileTime>
	^ self compilationTarget pointerAlignment
]

{ #category : #sizes }
MbndPointerLikeType >> instanceSize [
	<compileTime>
	^ self compilationTarget pointerSize
]
