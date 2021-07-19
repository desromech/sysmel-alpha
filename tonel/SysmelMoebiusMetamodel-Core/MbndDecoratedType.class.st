Class {
	#name : #MbndDecoratedType,
	#superclass : #MbndDerivedType,
	#instVars : [
		'decorations'
	],
	#category : #'SysmelMoebiusMetamodel-Core-Type'
}

{ #category : #accessing }
MbndDecoratedType class >> typeName [
	^ #_DecoratedType
]

{ #category : #visiting }
MbndDecoratedType >> accept: aVisitor [
	^ aVisitor visitDecoratedType: self
]

{ #category : #adding }
MbndDecoratedType >> addDefaultConversionRules [
	super addDefaultConversionRules.
	baseType ifNotNil: [ 
		self addConversionTo: baseType rule: MbndDecorationChangeTypeConversionRule.
	].

]

{ #category : #converting }
MbndDecoratedType >> analyzeReinterpretCastNode: node to: targetType with: analyzer [
	^ baseType analyzeReinterpretCastNode: node to: targetType with: analyzer
]

{ #category : #'semantic analysis' }
MbndDecoratedType >> analyzeUnboundExpandedMessageSendNode: node with: analyzer [
	"Try to delegate to the base type."
	^ baseType analyzeExpandedMessageSendNode: node with: analyzer
]

{ #category : #'semantic analysis' }
MbndDecoratedType >> analyzeUnboundUnexpandedMessageSendNode: node with: analyzer [
	"Try to delegate to the base type."
	^ baseType analyzeUnexpandedMessageSendNode: node with: analyzer
]

{ #category : #'semantic analysis' }
MbndDecoratedType >> analyzeUnhandledUnboundExpandedMessageSendNode: node with: analyzer [
	"Try to delegate to the base type."
	^ baseType analyzeUnhandledUnboundExpandedMessageSendNode: node with: analyzer
]

{ #category : #converting }
MbndDecoratedType >> asCVariadicTypeRequiredAt: position [
	^ baseType asCVariadicTypeRequiredAt: position
]

{ #category : #converting }
MbndDecoratedType >> asMutableValueType [
	^ baseType asMutableValueType withDecorations: decorations
]

{ #category : #converting }
MbndDecoratedType >> asPointerType [
	^ baseType asPointerType withDecorations: decorations
]

{ #category : #converting }
MbndDecoratedType >> asReferenceType [
	^ baseType asReferenceType withDecorations: decorations
]

{ #category : #converting }
MbndDecoratedType >> asSuperArgumentType [
	^ baseType asSuperArgumentType withDecorations: decorations
]

{ #category : #converting }
MbndDecoratedType >> asUndecoratedClassType [
	^ baseType asUndecoratedClassType
]

{ #category : #testing }
MbndDecoratedType >> canUnderstand: aSelector [
	<compileTime>
	(super canUnderstand: aSelector) ifTrue: [ ^ true ].
	^ baseType ifNil: [ false ] ifNotNil: [ baseType canUnderstand: aSelector ]
]

{ #category : #accessing }
MbndDecoratedType >> decorations [
	^ decorations
]

{ #category : #accessing }
MbndDecoratedType >> decorations: anObject [
	decorations := anObject
]

{ #category : #'default values' }
MbndDecoratedType >> defaultValueAt: aPosition [
	^ baseType defaultValueAt: aPosition
]

{ #category : #initialization }
MbndDecoratedType >> initialize [
	super initialize.
	decorations ifNil: [ decorations := #() ].
]

{ #category : #sizes }
MbndDecoratedType >> instanceAlignment [
	<compileTime>
	^ baseType instanceAlignment
]

{ #category : #sizes }
MbndDecoratedType >> instanceSize [
	<compileTime>
	^ baseType instanceSize
]

{ #category : #'testing methods' }
MbndDecoratedType >> isConstantType [
	^ decorations includes: #const
]

{ #category : #testing }
MbndDecoratedType >> isCopyable [
	^ baseType isCopyable
]

{ #category : #'testing methods' }
MbndDecoratedType >> isDecorationType [
	^ true
]

{ #category : #testing }
MbndDecoratedType >> isMoveable [
	^ baseType isMoveable
]

{ #category : #'testing methods' }
MbndDecoratedType >> isPossibleToLoadReferences [
	^ baseType isPossibleToLoadReferences
]

{ #category : #'testing methods' }
MbndDecoratedType >> isVolatileType [
	^ decorations includes: #volatile
]

{ #category : #'as yet unclassified' }
MbndDecoratedType >> lookupOverloadedFinalSelector: selector [
	baseType ifNil: [ ^ super lookupOverloadedFinalSelector: selector].
	
	(super lookupOverloadedFinalSelector: selector) ifNotNil: [ :found | ^ found ].
	^ baseType lookupOverloadedFinalSelector: selector
]

{ #category : #'as yet unclassified' }
MbndDecoratedType >> mbndLookupCompileTimeExposedMethod: selector [
	(super mbndLookupCompileTimeExposedMethod: selector) ifNotNil: [ :found | ^ found ].
	baseType ifNil: [ ^ nil ].
	^ baseType mbndLookupCompileTimeExposedMethod: selector
]

{ #category : #testing }
MbndDecoratedType >> pointerRank [
	^ baseType pointerRank
]

{ #category : #printing }
MbndDecoratedType >> printOn: aStream [
	name ifNotNil: [ ^ super printOn: aStream ].
	baseType printOn: aStream.
	decorations do: [ :decoration |
		aStream space; nextPutAll: decoration
	].

]

{ #category : #printing }
MbndDecoratedType >> qualifiedName [
	<compileTime>
	name ifNotNil: [ ^ super qualifiedName ].
	^ ByteString streamContents: [ :out |
		self printOn: out
	]
]

{ #category : #accessing }
MbndDecoratedType >> slotLayout [
	^ baseType slotLayout
]

{ #category : #'type composition' }
MbndDecoratedType >> tempRefFor: anAddressSpace [
	<compileTime>
	^ baseType tempRefFor: anAddressSpace
]

{ #category : #'testing methods' }
MbndDecoratedType >> withoutDecorations [
	^ baseType withoutDecorations
]

{ #category : #'type composition' }
MbndDecoratedType >> withoutTopDecorations [
	^ baseType
]
