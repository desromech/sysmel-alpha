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

{ #category : #'testing methods' }
MbndDecoratedType >> isDecorationType [
	^ true
]

{ #category : #testing }
MbndDecoratedType >> isNonCopyable [
	^ baseType isNonCopyable
]

{ #category : #testing }
MbndDecoratedType >> isNonMoveable [
	^ baseType isNonMoveable
]

{ #category : #'testing methods' }
MbndDecoratedType >> isPossibleToLoadReferences [
	^ baseType isPossibleToLoadReferences
]

{ #category : #'testing methods' }
MbndDecoratedType >> isVolatileType [
	^ decorations includes: #volatile
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
