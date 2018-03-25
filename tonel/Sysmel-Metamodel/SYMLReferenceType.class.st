Class {
	#name : #SYMLReferenceType,
	#superclass : #SYMLType,
	#instVars : [
		'referenced'
	],
	#category : #Sysmel-Metamodel-Types
}

{ #category : #testing }
SYMLReferenceType >> canBeNode: node coercedImplicitlyInto: targetType at: aSourcePosition [
	(super canBeNode: node coercedImplicitlyInto: targetType at: aSourcePosition) ifTrue: [ ^ true ].
	^ referenced canBeNode: node coercedImplicitlyInto: targetType at: aSourcePosition
]

{ #category : #testing }
SYMLReferenceType >> canBeNode: node coercedImplicitlyIntoCVariadicAt: aSourcePosition [
	(super canBeNode: node coercedImplicitlyIntoCVariadicAt: aSourcePosition) ifTrue: [ ^ true ].
	^ referenced canBeNode: node coercedImplicitlyIntoCVariadicAt: aSourcePosition
]

{ #category : #'meta evaluation' }
SYMLReferenceType >> cleanType [
	^ referenced cleanType ref
]

{ #category : #'meta evaluation' }
SYMLReferenceType >> concreteTypeForNode: aNode [
	^ (referenced concreteTypeForNode: aNode) ref
]

{ #category : #'meta evaluation' }
SYMLReferenceType >> evaluateValueWithoutReferences: aValue inEnvironment: evaluationEnvironment [
	^ aValue value value sysmelValueWithType: referenced inEnvironment: evaluationEnvironment
]

{ #category : #testing }
SYMLReferenceType >> isReferenceType [
	^ true
]

{ #category : #printing }
SYMLReferenceType >> printOn: aStream [
	aStream print: referenced; nextPutAll: ' ref'
]

{ #category : #accessing }
SYMLReferenceType >> referenced [
	^ referenced
]

{ #category : #accessing }
SYMLReferenceType >> referenced: anObject [
	referenced := anObject
]

{ #category : #coercion }
SYMLReferenceType >> ssaCoerceImplicitly: value to: targetType with: builder at: aSourcePosition [
	| cleanReferenced |
	cleanReferenced := referenced cleanType.
	cleanReferenced == targetType ifTrue: [
		cleanReferenced isFunctionType ifTrue: [ ^ value ].
		^ (builder load: value)
			volatile: referenced isVolatileType;
			yourself
	].
	
	^ super ssaCoerceImplicitly: value to: targetType with: builder at: aSourcePosition
]

{ #category : #coercion }
SYMLReferenceType >> ssaCoerceImplicitly: value toCVariadicWith: builder at: aSourcePosition [
	| cleanReferenced |
	cleanReferenced := referenced cleanType.
	cleanReferenced isFunctionType ifTrue: [ ^ value ].
	^ (builder load: value)
			volatile: referenced isVolatileType;
			yourself
]

{ #category : #'meta evaluation' }
SYMLReferenceType >> valueType [
	^ referenced valueType
]
