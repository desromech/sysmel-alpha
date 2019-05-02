Class {
	#name : #MbndPointerType,
	#superclass : #MbndPointerLikeType,
	#category : #'SysmelMoebiusMetamodel-Core-Type'
}

{ #category : #accessing }
MbndPointerType class >> typeName [
	^ #_PointerType
]

{ #category : #visiting }
MbndPointerType >> accept: aVisitor [
	^ aVisitor visitPointerType: self
]

{ #category : #converting }
MbndPointerType >> asCVariadicTypeRequiredAt: position [
	^ self
]

{ #category : #'default values' }
MbndPointerType >> defaultValue [
	^ MbndValue value: nil type: self
]

{ #category : #initialization }
MbndPointerType >> initializeBasicTypeTrait [
	super initializeBasicTypeTrait.
	self
		onMacroSelectors: #(value _) do: [ :node :builder |
			(builder reference: node receiver assignValue: node arguments first)
				position: node
		];
		onMacroSelector: #value: do: [ :node :builder |
			self halt
		];
		onMacroSelectors: #(subscriptAt: at:) do: [ :node :builder |
			self halt
		];
		onMacroSelector: #+ do: [ :node :builder |
			self halt
		];
		onMacroSelector: #- do: [ :node :builder |
			self halt
		].
]

{ #category : #'testing methods' }
MbndPointerType >> isPointerType [
	^ true
]

{ #category : #printing }
MbndPointerType >> printOn: aStream [
	baseType printOn: aStream.
	aStream nextPutAll: ' pointer'
]

{ #category : #'type composition' }
MbndPointerType >> withoutDecorations [
	^ baseType withoutDecorations pointerFor: addressSpace
]
