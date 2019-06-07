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
MbndDecoratedType >> asCVariadicTypeRequiredAt: position [
	^ baseType asCVariadicTypeRequiredAt: position
]

{ #category : #converting }
MbndDecoratedType >> asPointerType [
	^ baseType asPointerType withDecorations: decorations
]

{ #category : #converting }
MbndDecoratedType >> asReferenceType [
	^ baseType asReferenceType withDecorations: decorations
]

{ #category : #accessing }
MbndDecoratedType >> decorations [
	^ decorations
]

{ #category : #accessing }
MbndDecoratedType >> decorations: anObject [
	decorations := anObject
]

{ #category : #initialization }
MbndDecoratedType >> initialize [
	super initialize.
	decorations ifNil: [ decorations := #() ].
]

{ #category : #'testing methods' }
MbndDecoratedType >> isConstantType [
	^ decorations includes: #const
]

{ #category : #'testing methods' }
MbndDecoratedType >> isDecorationType [
	^ true
]

{ #category : #'testing methods' }
MbndDecoratedType >> isVolatileType [
	^ decorations includes: #volatile
]

{ #category : #printing }
MbndDecoratedType >> printOn: aStream [
	baseType printOn: aStream.
	decorations do: [ :decoration |
		aStream space; nextPutAll: decoration
	].

]

{ #category : #'testing methods' }
MbndDecoratedType >> withoutDecorations [
	^ baseType withoutDecorations
]

{ #category : #'type composition' }
MbndDecoratedType >> withoutTopDecorations [
	^ baseType
]
