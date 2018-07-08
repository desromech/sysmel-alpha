Class {
	#name : #SYMLSimpleMetaType,
	#superclass : #SYMLAbstractMetaType,
	#category : #'Sysmel-Metamodel-Type'
}

{ #category : #converting }
SYMLSimpleMetaType >> asReceiverType [
	^ self
]

{ #category : #'as yet unclassified' }
SYMLSimpleMetaType >> createTypeInstanceSlots [
	^ #()
]

{ #category : #'as yet unclassified' }
SYMLSimpleMetaType >> createTypeInstanceSlotsFor: typeInstance [
	^ #()
]

{ #category : #'code generation' }
SYMLSimpleMetaType >> generateSSATypeInfo [
	^ SLVMConstant type: self ssaType value: 0
]

{ #category : #testing }
SYMLSimpleMetaType >> isMetaObjectType [
	^ true
]

{ #category : #accessing }
SYMLSimpleMetaType >> mangledName [
	^ mangledName ifNil: [mangledName := ByteString streamContents: [ :out |
			out
				nextPutAll: instanceType mangledName;
				nextPutAll: '_meta'.
		]
	]
]

{ #category : #printing }
SYMLSimpleMetaType >> printOn: aStream [
	instanceType printOn: aStream.
	aStream nextPutAll: ' type'
]

{ #category : #accessing }
SYMLSimpleMetaType >> supertype [
	^ instanceType ifNotNil: [ instanceType supertype ifNotNil: [:ist | ist type ]]
]

{ #category : #printing }
SYMLSimpleMetaType >> type [
	^ self compilationTarget metaType
]
