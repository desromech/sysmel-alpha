Class {
	#name : #SysmelNativeTypeCache,
	#superclass : #Object,
	#classVars : [
		'ArrayTypeCache',
		'GenericTypeCache'
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

{ #category : #'as yet unclassified' }
SysmelNativeTypeCache class >> genericTypeCache [
	^ GenericTypeCache ifNil: [ GenericTypeCache := Dictionary new ]
]

{ #category : #'as yet unclassified' }
SysmelNativeTypeCache class >> getGeneric: generic withArguments: genericArguments orCreateWith: genericInstatiationBlock [
	^ self genericTypeCache at: { generic . genericArguments } ifAbsentPut: genericInstatiationBlock
]
