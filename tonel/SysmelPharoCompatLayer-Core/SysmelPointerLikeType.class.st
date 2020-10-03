Class {
	#name : #SysmelPointerLikeType,
	#superclass : #SysmelDerivedType,
	#instVars : [
		'storage',
		'offset'
	],
	#classInstVars : [
		'addressSpace'
	],
	#category : #'SysmelPharoCompatLayer-Core-PrimitiveTypes'
}

{ #category : #accessing }
SysmelPointerLikeType class >> addressSpace [
	^ addressSpace
]

{ #category : #'as yet unclassified' }
SysmelPointerLikeType class >> adoptFrom: aStorage [
	^ self adoptFrom: aStorage offset: 0
]

{ #category : #'as yet unclassified' }
SysmelPointerLikeType class >> adoptFrom: aStorage offset: anOffset [
	^ self basicNew
		adoptStorageFrom: aStorage offset: anOffset;
		yourself
]

{ #category : #'as yet unclassified' }
SysmelPointerLikeType class >> genericAddressSpace [
	^ #generic
]

{ #category : #testing }
SysmelPointerLikeType class >> isAbstract [
	^ self == SysmelPointerLikeType
]

{ #category : #'as yet unclassified' }
SysmelPointerLikeType >> adoptStorageFrom: newStorage [
	self adoptStorageFrom: newStorage offset: 0
]

{ #category : #'as yet unclassified' }
SysmelPointerLikeType >> adoptStorageFrom: newStorage offset: anOffset [
	storage := newStorage.
	offset := anOffset.
]
