"
I provide the fundamental protocol for the MoebiusBand type system. I am the core of this Meta Object Protocol that expands the Smalltalk MOP with macros, and primitive types.
"
Trait {
	#name : #TMbndAbstractType,
	#category : #'MoebiusBandMetamodel-Core-Type'
}

{ #category : #sizes }
TMbndAbstractType >> instanceAlignment [
	^ self explicitRequirement
]

{ #category : #sizes }
TMbndAbstractType >> instanceSize [
	^ self explicitRequirement
]

{ #category : #'testing methods' }
TMbndAbstractType >> isLiteralArrayType [
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
TMbndAbstractType >> isVoidType [
	^ false
]

{ #category : #'macro expansion' }
TMbndAbstractType >> lookupMacroSelector: aSelector [
	^ self supertype ifNotNil: [ :st | st lookupMacroSelector: aSelector ]
]

{ #category : #accessing }
TMbndAbstractType >> supertype [
	"I answer a supertype." 
	^ nil
]

{ #category : #accessing }
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
