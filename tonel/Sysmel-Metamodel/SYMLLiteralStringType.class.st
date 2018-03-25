Class {
	#name : #SYMLLiteralStringType,
	#superclass : #SYMLLiteralType,
	#category : #Sysmel-Metamodel-Types
}

{ #category : #coercion }
SYMLLiteralStringType >> canBeNode: node coercedImplicitlyInto: targetType at: aSourcePosition [
	| characterType |
	(super canBeNode: node coercedImplicitlyInto: targetType at: aSourcePosition) ifTrue: [ ^ true ].
	(targetType isPointerType and: [ targetType pointed isConstantType ]) ifTrue: [ 
		characterType := targetType pointed cleanType.
		(characterType isIntegerType and: [characterType size = 1]) ifTrue: [ ^ true ].
	].

	^ false
]

{ #category : #coercion }
SYMLLiteralStringType >> canBeNode: node coercedImplicitlyIntoCVariadicAt: aSourcePosition [
	^ true
]

{ #category : #accessing }
SYMLLiteralStringType >> name [
	^ #_LiteralString
]

{ #category : #coercion }
SYMLLiteralStringType >> ssaCoerceImplicitly: value to: targetType with: builder at: aSourcePosition [
	| characterType |
	(targetType isPointerType and: [ targetType pointed isConstantType ]) ifTrue: [ 
		characterType := targetType pointed cleanType.
		(characterType isIntegerType and: [characterType size = 1]) ifTrue: [
			^ self ssaCoerceImplicitly: value toCVariadicWith: builder at: aSourcePosition
		].
	].

	^ super ssaCoerceImplicitly: value to: targetType with: builder at: aSourcePosition
]

{ #category : #coercion }
SYMLLiteralStringType >> ssaCoerceImplicitly: value toCVariadicWith: builder at: aSourcePosition [
	^ builder constCString: value
]
