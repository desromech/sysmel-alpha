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

{ #category : #adding }
MbndPointerType >> addDefaultConversionRules [
	| uintPointerType intPointerType |
	super addDefaultConversionRules.
	self isTrait ifTrue: [ 
		uintPointerType := self compilationTarget uintPointerType.
		intPointerType := self compilationTarget intPointerType.
		uintPointerType | intPointerType addExplicitConversionTo: self rule: MbndPointerToIntegerTypeConversionRule.
		self addExplicitConversionTo: uintPointerType | intPointerType rule: MbndIntegerToPointerTypeConversionRule.
	].

]

{ #category : #initialization }
MbndPointerType >> addInstanceMacros [
	self class == MbndPointerType ifFalse: [ ^ self ].
	self isTrait ifFalse: [ ^ self ].
	self
		onMacroSelectors: #(value _) do: [ :node :builder |
			(builder pointerAsReference: node receiver)
				position: node
		];
		onMacroSelector: #value: do: [ :node :builder |
			| ref |
			ref := (builder pointerAsReference: node receiver)
				position: node;
				yourself.
			(builder reference: ref assignValue: node arguments first)
				position: node
		];
		onMacroSelector: #subscriptAt: do: [ :node :builder |
			(builder pointer: node receiver elementReferenceAt: node arguments first)
				position: node;
				isOneBasedIndex: false;
				yourself.
		];
		onMacroSelector: #at: do: [ :node :builder |
			(builder pointer: node receiver elementReferenceAt: node arguments first)
				position: node;
				isOneBasedIndex: true;
				yourself.
		];
		onMacroSelector: #+ do: [ :node :builder |
			self halt
		];
		onMacroSelector: #- do: [ :node :builder |
			self halt
		].
]

{ #category : #converting }
MbndPointerType >> asCVariadicTypeRequiredAt: position [
	^ self
]

{ #category : #converting }
MbndPointerType >> asPointerType [
	^ self
]

{ #category : #converting }
MbndPointerType >> asReferenceType [
	^ baseType refFor: addressSpace
]

{ #category : #'default values' }
MbndPointerType >> defaultValueAt: aPosition [
	^ MbndValue value: nil type: self
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
