Class {
	#name : #MbndUndefinedType,
	#superclass : #MbndOpaqueType,
	#category : #'SysmelMoebiusMetamodel-Core-Type'
}

{ #category : #accessing }
MbndUndefinedType class >> typeName [
	^ #_UndefinedType
]

{ #category : #visiting }
MbndUndefinedType >> accept: aVisitor [
	^ aVisitor visitUndefinedType: self
]

{ #category : #adding }
MbndUndefinedType >> addDefaultConversionRules [
	super addDefaultConversionRules.
	
	self
		addConversionTo: self compilationTarget voidType rule: MbndLiteralValueTypeChangeConversionRule;
		addConversionRule: (MbndLiteralValueTypeChangeConversionRule when: [:source :target |
			target withoutTopDecorations isPointerType
	])

]

{ #category : #converting }
MbndUndefinedType >> asCVariadicTypeRequiredAt: position [
	^ self compilationTarget voidType pointer
]

{ #category : #'default values' }
MbndUndefinedType >> defaultValueAt: aPosition [
	^ MbndValue value: nil type: self
]

{ #category : #'testing methods' }
MbndUndefinedType >> isUndefinedType [
	^ true
]
