Class {
	#name : #SysmelNativeTypeCache,
	#superclass : #Object,
	#classVars : [
		'ArrayTypeCache'
	],
	#category : #'SysmelPharoCompatLayer-Core-PrimitiveTypes'
}

{ #category : #'derived types' }
SysmelNativeTypeCache class >> arrayOf: baseType elements: elements [
	self assert: baseType isSysmelNativeType.
	^ self arrayTypeCache at: {baseType . elements} ifAbsentPut: [ SysmelArrayType instanceFor: baseType elements: elements ]
]

{ #category : #'as yet unclassified' }
SysmelNativeTypeCache class >> arrayTypeCache [
	^ ArrayTypeCache ifNil: [ ArrayTypeCache := Dictionary new ]
]
