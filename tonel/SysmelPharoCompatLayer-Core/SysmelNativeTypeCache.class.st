Class {
	#name : #SysmelNativeTypeCache,
	#superclass : #Object,
	#classVars : [
		'ArraySliceTypeCache',
		'ArrayTypeCache',
		'GenericTypeCache',
		'PointerTypeCache'
	],
	#category : #'SysmelPharoCompatLayer-Core-PrimitiveTypes'
}

{ #category : #'derived types' }
SysmelNativeTypeCache class >> arrayOf: baseType elements: elements [
	self assert: baseType isSysmelNativeType.
	^ self arrayTypeCache at: {baseType . elements} ifAbsentPut: [ SysmelArrayType instanceFor: baseType elements: elements ]
]

{ #category : #'derived types' }
SysmelNativeTypeCache class >> arraySliceOf: baseType [
	self assert: baseType isSysmelNativeType.
	^ self arraySliceTypeCache at: baseType ifAbsentPut: [ SysmelArraySliceType instanceFor: baseType ]
]

{ #category : #'as yet unclassified' }
SysmelNativeTypeCache class >> arraySliceTypeCache [
	^ ArraySliceTypeCache ifNil: [ ArraySliceTypeCache := Dictionary new ]
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

{ #category : #'as yet unclassified' }
SysmelNativeTypeCache class >> pointerFor: addressSpace to: baseType [
	^ self pointerTypeCache at: { baseType . addressSpace } ifAbsentPut: [ SysmelPointerType instanceFor: addressSpace to: baseType ]
]

{ #category : #'as yet unclassified' }
SysmelNativeTypeCache class >> pointerTypeCache [
	^ PointerTypeCache ifNil: [ PointerTypeCache := Dictionary new ]
]
