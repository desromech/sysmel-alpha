Class {
	#name : #SysmelPointerType,
	#superclass : #SysmelPointerLikeType,
	#category : #'SysmelPharoCompatLayer-Core-PrimitiveTypes'
}

{ #category : #'as yet unclassified' }
SysmelPointerType class >> initializeFor: theAddressSpace to: theBaseType [
	addressSpace := theAddressSpace.
	baseType := theBaseType.
	theAddressSpace = self genericAddressSpace ifTrue: [
		name := baseType asString , ' pointer'
	] ifFalse: [
		name := '(', baseType asString , ' pointerFor: ', addressSpace printString, ')'
	].
]

{ #category : #'as yet unclassified' }
SysmelPointerType class >> instanceFor: theAddressSpace to: theBaseType [
	^ self newAnonymousSubclass
		initializeFor: theAddressSpace to: theBaseType;
		yourself
]

{ #category : #testing }
SysmelPointerType class >> isAbstract [
	^ self == SysmelPointerType
]

{ #category : #testing }
SysmelPointerType class >> isPointerType [
	^ true
]

{ #category : #accessing }
SysmelPointerType >> at: index [
	^ self atOffset: index - 1
]

{ #category : #accessing }
SysmelPointerType >> at: index put: value [
	^ self atOffset: index - 1 put: value
]

{ #category : #accessing }
SysmelPointerType >> atOffset: elementOffset [
	| baseType |
	baseType := self class baseType.
	^ baseType newFromBytes: storage position: 1 + offset + (elementOffset * baseType alignedInstanceSize)
]

{ #category : #accessing }
SysmelPointerType >> atOffset: elementOffset put: value [
	| baseType |
	baseType := self class baseType.
	^ baseType storeValue: value bytesIn: storage position: 1 + offset + (elementOffset * baseType alignedInstanceSize)
]

{ #category : #'as yet unclassified' }
SysmelPointerType >> from: firstIndex until: endIndex [
	^ self class baseType arraySlice elements: self offset: firstIndex size: endIndex - firstIndex
]

{ #category : #'as yet unclassified' }
SysmelPointerType >> until: size [
	^ self from: 0 until: size
]

{ #category : #evaluating }
SysmelPointerType >> value [
	^ self atOffset: 0
]

{ #category : #evaluating }
SysmelPointerType >> value: newValue [
	^ self atOffset: 0 put: newValue
]
