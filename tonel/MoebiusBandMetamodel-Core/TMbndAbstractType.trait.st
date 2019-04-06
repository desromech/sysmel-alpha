"
I provide the fundamental protocol for the MoebiusBand type system. I am the core of this Meta Object Protocol that expands the Smalltalk MOP with macros, and primitive types.
"
Trait {
	#name : #TMbndAbstractType,
	#traits : 'TMbndProgramEntity',
	#classTraits : 'TMbndProgramEntity classTrait',
	#category : #'MoebiusBandMetamodel-Core-Type'
}

{ #category : #'type hierarchy' }
TMbndAbstractType >> allSubtypes [
	| result |
	result := OrderedCollection new.
	self allSubtypesDo: [ :st | result add: st ].
	^ result
]

{ #category : #'type hierarchy' }
TMbndAbstractType >> allSubtypesDo: aBlock [
	self subtypes do: [ :st | st withAllSubtypesDo: aBlock ]
]

{ #category : #'semantic analysis' }
TMbndAbstractType >> analyzeMessageSendNodeWithDynamicSelector: node with: analyzer [
	self error: 'Cannout perform message to value of type {1}.' format: {self fullName} at: node
]

{ #category : #'semantic analysis' }
TMbndAbstractType >> analyzeReferenceNode: referenceNode with: analyzer [
	^ MbndAstLiteralValueNode new
		value: self;
		type: self type;
		position: referenceNode;
		yourself
]

{ #category : #'semantic analysis' }
TMbndAbstractType >> analyzeUnboundExpandedMessageSendNode: node with: analyzer [
	self error: 'Cannot send unknown message {1} to value of type {2}.' format: {node selector printValueString. self fullName} at: node
]

{ #category : #'semantic analysis' }
TMbndAbstractType >> analyzeUnexpandedMessageSendNode: node with: analyzer [
	| selector macroMethod |
	node selector isLiteralSymbolValueNode ifTrue: [
		selector := node selector value.
		macroMethod := self lookupMacroSelector: selector.
		macroMethod ifNotNil: [
			^ macroMethod expandMessageNode: node with: analyzer
		].
	].

	^ analyzer visitNode: node asExpandedMessageSend
]

{ #category : #accessing }
TMbndAbstractType >> fullName [
	self explicitRequirement
]

{ #category : #sizes }
TMbndAbstractType >> instanceAlignment [
	^ self explicitRequirement
]

{ #category : #sizes }
TMbndAbstractType >> instanceSize [
	^ self explicitRequirement
]

{ #category : #'testing methods' }
TMbndAbstractType >> isAggregateType [
	^ false
]

{ #category : #'testing methods' }
TMbndAbstractType >> isArrayType [
	^ false
]

{ #category : #'testing methods' }
TMbndAbstractType >> isDerivedType [
	^ false
]

{ #category : #'testing methods' }
TMbndAbstractType >> isLiteralArrayType [
	^ false
]

{ #category : #'testing methods' }
TMbndAbstractType >> isLiteralBooleanFalseType [
	^ false
]

{ #category : #'testing methods' }
TMbndAbstractType >> isLiteralBooleanTrueType [
	^ false
]

{ #category : #'testing methods' }
TMbndAbstractType >> isLiteralBooleanType [
	^ false
]

{ #category : #'testing methods' }
TMbndAbstractType >> isLiteralCharacterType [
	^ false
]

{ #category : #'testing methods' }
TMbndAbstractType >> isLiteralFloatType [
	^ false
]

{ #category : #'testing methods' }
TMbndAbstractType >> isLiteralIntegerType [
	^ false
]

{ #category : #'testing methods' }
TMbndAbstractType >> isLiteralNumberType [
	^ false
]

{ #category : #'testing methods' }
TMbndAbstractType >> isLiteralStringType [
	^ false
]

{ #category : #'testing methods' }
TMbndAbstractType >> isLiteralSymbolType [
	^ false
]

{ #category : #'testing methods' }
TMbndAbstractType >> isLiteralValueType [
	^ false
]

{ #category : #'testing methods' }
TMbndAbstractType >> isMetaType [
	^ false
]

{ #category : #'testing methods' }
TMbndAbstractType >> isOpaqueType [
	^ false
]

{ #category : #'testing methods' }
TMbndAbstractType >> isPointerType [
	^ false
]

{ #category : #'testing methods' }
TMbndAbstractType >> isPrimitiveBooleanType [
	^ false
]

{ #category : #'testing methods' }
TMbndAbstractType >> isPrimitiveFloatType [
	^ false
]

{ #category : #'testing methods' }
TMbndAbstractType >> isPrimitiveIntegerType [
	^ false
]

{ #category : #'testing methods' }
TMbndAbstractType >> isPrimitiveType [
	^ false
]

{ #category : #'testing methods' }
TMbndAbstractType >> isReferenceType [
	^ false
]

{ #category : #'testing methods' }
TMbndAbstractType >> isReturnType [
	^ false
]

{ #category : #'testing methods' }
TMbndAbstractType >> isStructureType [
	^ false
]

{ #category : #'testing methods' }
TMbndAbstractType >> isUndefinedType [
	^ false
]

{ #category : #'testing methods' }
TMbndAbstractType >> isUnionType [
	^ false
]

{ #category : #'testing methods' }
TMbndAbstractType >> isVoidType [
	^ false
]

{ #category : #'macro expansion' }
TMbndAbstractType >> lookupMacroSelector: aSelector [
	^ self supertype ifNotNil: [ :st | st lookupMacroSelector: aSelector ]
]

{ #category : #methods }
TMbndAbstractType >> lookupSelector: selector [
	^ nil
]

{ #category : #'type hierarchy' }
TMbndAbstractType >> subtypeAdded: aSubtype [
]

{ #category : #'type hierarchy' }
TMbndAbstractType >> subtypeRemoved: aSubtype [
]

{ #category : #'type hierarchy' }
TMbndAbstractType >> subtypes [
	^ #()
]

{ #category : #'type hierarchy' }
TMbndAbstractType >> subtypesDo: aBlock [
	self subtypes do: aBlock
]

{ #category : #'type hierarchy' }
TMbndAbstractType >> supertype [
	"I answer a supertype." 
	^ nil
]

{ #category : #'type hierarchy' }
TMbndAbstractType >> type [
	"I answer a meta type."
	^ nil
]

{ #category : #sizes }
TMbndAbstractType >> valueAlignment [
	^ self instanceAlignment
]

{ #category : #sizes }
TMbndAbstractType >> valueSize [
	^ self instanceSize
]

{ #category : #'type hierarchy' }
TMbndAbstractType >> withAllSubtypes [
	| result |
	result := OrderedCollection new.
	self withAllSubtypesDo: [ :st | result add: st ].
	^ result
]

{ #category : #'type hierarchy' }
TMbndAbstractType >> withAllSubtypesDo: aBlock [
	aBlock value: self.
	self allSubtypesDo: aBlock
]

{ #category : #'type hierarchy' }
TMbndAbstractType >> withSubtypesDo: aBlock [
	aBlock value: self.
	self subtypesDo: aBlock
]
